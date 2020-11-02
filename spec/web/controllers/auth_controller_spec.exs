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

        describe "user creation/search logic" do
          context "when user with provided uid already exists" do
            let! :user, do: insert(:user, uid: ueberauth().extra.raw_info.user["id"] |> Integer.to_string)

            it "redirects to front-end with user info" do
              redirect_url = success_conn() |> AuthController.callback(%{}) |> redirected_to(302)
              expect(redirect_url =~ "last_name") |> to(be true)
              expect(redirect_url =~ "uid") |> to(be true)
              expect(redirect_url =~ "auth_token") |> to(be true)
              expect(redirect_url =~ "image_url") |> to(be true)
            end

            it "should not create user" do
              initial_count = entities_count(User)
              success_conn() |> AuthController.callback(%{}) |> redirected_to(302)
              expect(entities_count(User)) |> to(eq(initial_count))
            end

            it "includes show_info: false" do
              redirect_url = success_conn() |> AuthController.callback(%{}) |> redirected_to(302)
              expect(redirect_url =~ "show_info=false") |> to(be true)
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
              expect(redirect_url =~ "last_name") |> to(be true)
              expect(redirect_url =~ "uid") |> to(be true)
              expect(redirect_url =~ "auth_token") |> to(be true)
              expect(redirect_url =~ "image_url") |> to(be true)
            end

            it "includes show_info: true" do
              redirect_url = success_conn() |> AuthController.callback(%{}) |> redirected_to(302)
              expect(redirect_url =~ "show_info=true") |> to(be true)
            end
          end
        end

        context "when user serch/creation failed" do
          let :message, do: "Bad_things_happened"

          before do
            mock Squadster.Accounts, :find_or_create_user, {:error, message()}
          end

          it "redirects to front-end with error message" do
            redirect_url = success_conn() |> AuthController.callback(%{}) |> redirected_to(302)
            expect(redirect_url =~ "Error") |> to(be true)
            expect(redirect_url =~ message()) |> to(be true)
          end
        end

        context "when there is state param included" do
          context "and when it has hash_id" do
            before do
              mock NormalizeQueue, :start_link
            end

            context "and when there is a squad with this hash_id and link invitations enabled" do
              let :hash_id, do: "YFuzkbC6ONC4pEM3AhIBhA=="
              let! :squad, do: insert(:squad, hash_id: hash_id(), link_invitations_enabled: true)

              it "redirects to front-end with user info" do
                redirect_url = success_conn() |> AuthController.callback(%{"state" => "hash_id=#{hash_id()}"}) |> redirected_to(302)
                expect(redirect_url =~ "last_name") |> to(be true)
                expect(redirect_url =~ "uid") |> to(be true)
                expect(redirect_url =~ "auth_token") |> to(be true)
                expect(redirect_url =~ "image_url") |> to(be true)
              end
            end

            context "and when there in no squad with such hash_id and link invitations enabled" do
              it "redirects to front-end with user info" do
                redirect_url = success_conn() |> AuthController.callback(%{"state" => "hash_id=123"}) |> redirected_to(302)
                expect(redirect_url =~ "last_name") |> to(be true)
                expect(redirect_url =~ "uid") |> to(be true)
                expect(redirect_url =~ "auth_token") |> to(be true)
                expect(redirect_url =~ "image_url") |> to(be true)
              end

              it "includes warning message that indicates that the hash_id is invalid" do
                redirect_url =
                  success_conn()
                  |> AuthController.callback(%{"state" => "hash_id=123"})
                  |> redirected_to(302)

                expect(redirect_url =~ "warnings") |> to(be true)
                expect(redirect_url =~ "Invalid+hash_id") |> to(be true)
              end
            end

            context "and when it is 'mobile=ture'" do
              it "should render json instead of redirect" do
                response =
                  success_conn()
                  |> Phoenix.Controller.put_view(SquadsterWeb.AuthView)
                  |> AuthController.callback(%{"state" => "mobile=true"})

                expect response.status |> to(eq 200)
                expect response |> get_resp_header("content-type") |> to(eq ["application/json; charset=utf-8"])
              end
            end
          end

          context "and when there is no hash_id" do
            it "redirects to front-end with user info" do
              redirect_url = success_conn() |> AuthController.callback(%{"state" => "hello"}) |> redirected_to(302)
              expect(redirect_url =~ "last_name") |> to(be true)
              expect(redirect_url =~ "uid") |> to(be true)
              expect(redirect_url =~ "auth_token") |> to(be true)
              expect(redirect_url =~ "image_url") |> to(be true)
            end

            it "includes warning message that indicates that the state is invalid" do
              redirect_url = success_conn() |> AuthController.callback(%{"state" => "hello"}) |> redirected_to(302)
              expect(redirect_url =~ "warnings") |> to(be true)
              expect(redirect_url =~ "Invalid+state") |> to(be true)
            end
          end
        end
      end

      context "when auth failure accured" do
        let :message, do: "No_token_provided"
        let :failure_conn do
          %{build_conn() | assigns: %{ueberauth_failure: %{errors: [%{message: message()}]}}}
        end

        it "redirects to front-end with error message" do
          redirect_url = failure_conn() |> AuthController.callback(%{}) |> redirected_to(302)
          expect(redirect_url =~ "Error") |> to(be true)
          expect(redirect_url =~ message()) |> to(be true)
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
      user = reload(user())
      expect user.auth_token |> to(eq nil)
    end

    it "responds with status message" do
      conn = login_as(user()) |> delete_request()
      expect(conn.resp_body =~ "message") |> to(eq true)
    end
  end
end
