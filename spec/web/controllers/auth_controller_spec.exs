defmodule Squadster.Web.AuthControllerSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  import Mockery

  alias SquadsterWeb.AuthController
  alias Squadster.Accounts.User

  describe "vk.com OAuth" do
    let :provider, do: :vk

    def request(action, conn \\ build_conn()) do
      conn |> get(auth_path(conn, action, provider()))
    end

    describe "GET /api/auth/vk" do
      it "redirects to vk.com" do
        redirect_url = request(:request) |> redirected_to(302)
        expect(redirect_url =~ "https://oauth.vk.com/authorize") |> to(eq true)
      end
    end

    describe "GET /api/auth/vk/callback" do
      context "when vk auth is successful" do
        let :ueberauth, do: build(:ueberauth)
        let :success_conn, do: %{build_conn() | assigns: %{ueberauth_auth: ueberauth()}}

        it "redirects to front-end" do
          conn = request(:callback, success_conn())
          expect(conn |> redirected_to(302) =~ "squadster") |> to(eq true)
        end

        describe "user creation logic" do
          context "when user with provided token already exists" do
            let! :user, do: insert(:user, auth_token: ueberauth().credentials.token)

            it "redirects to front-end with user info" do
              redirect_url = success_conn() |> AuthController.callback(%{}) |> redirected_to(302)
              expect(redirect_url =~ "last_name")
              expect(redirect_url =~ "uid")
              expect(redirect_url =~ "auth_token")
              expect(redirect_url =~ "image_url")
            end
          end

          context "when it's new user" do
            it "creates user" do
              initial_count = entities_count(User)
              success_conn() |> AuthController.callback(%{}) |> redirected_to(302)
              expect(entities_count(User)) |> to(eq(initial_count + 1))
            end

            it "redirects to front-end with user info" do
              redirect_url = success_conn() |> AuthController.callback(%{}) |> redirected_to(302)
              expect(redirect_url =~ "last_name")
              expect(redirect_url =~ "uid")
              expect(redirect_url =~ "auth_token")
              expect(redirect_url =~ "image_url")
            end
          end
        end

        context "when user serch/creation failed" do
          let :message, do: "Bad things happened!"

          before do
            mock Squadster.Accounts, :find_or_create_user, {:error, message()}
          end

          it "redirects to front-end with error message" do
            redirect_url = success_conn() |> AuthController.callback(%{}) |> redirected_to(302)
            expect(redirect_url =~ "Error")
            expect(redirect_url =~ message())
          end
        end
      end

      context "when auth failure accured" do
        let :message, do: "No token provided"
        let :failure_conn do
          %{build_conn() | assigns: %{ueberauth_failure: %{errors: [%{message: message()}]}}}
        end

        it "redirects to front-end with error message" do
          redirect_url = failure_conn() |> AuthController.callback(%{}) |> redirected_to(302)
          expect(redirect_url =~ "Error")
          expect(redirect_url =~ message())
        end
      end
    end
  end

  describe "DELETE /api/auth" do
    def delete_request(conn \\ build_conn()) do
      conn |> delete(logout_path(conn, :destroy))
    end

    let :user, do: insert(:user)

    context "when user is not authenticated" do
      it "responds with an error" do
        expect delete_request().status |> to(eq(401))
      end
    end

    it "sets current_user token to nil" do
      login_as(user()) |> delete_request()
      user = User |> Repo.get(user().id)
      expect user.auth_token |> to(eq nil)
    end

    it "responds with status message" do
      conn = login_as(user()) |> delete_request()
      expect(conn.resp_body =~ "message") |> to(eq true)
    end
  end
end
