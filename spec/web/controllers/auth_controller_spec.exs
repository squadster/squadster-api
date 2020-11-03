defmodule Squadster.Web.AuthControllerSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  import Mockery

  alias SquadsterWeb.AuthController
  alias Squadster.Accounts.User

  describe "vk.com OAuth" do
    let provider: :vk

    def request(action, conn \\ build_conn()) do
      conn |> get(auth_path(conn, action, provider()))
    end

    describe "GET /api/auth/vk" do
      it "redirects to vk.com" do
        redirect_url = request(:request) |> redirected_to(302)
        expect(redirect_url) |> to(match "https://oauth.vk.com/authorize")
      end
    end

    describe "GET /api/auth/vk/callback" do
      context "when vk auth is successful" do
        let ueberauth: build(:ueberauth)
        let success_conn: %{build_conn() | assigns: %{ueberauth_auth: ueberauth()}}
        let make_request: url()

        it "redirects to front-end" do
          conn = request(:callback, success_conn())
          expect(conn |> redirected_to(302)) |> to(match "squadster")
        end

        describe "user creation/search logic" do
          defmodule RedirectsToFrontendWithUserInfo do
            use ESpec, shared: true

            @front_end_url Application.fetch_env!(:ueberauth, Ueberauth.Strategy.VK.OAuth)[:base_redirect_url]

            let_overridable :url

            it "redirects to front-end" do
              expect(url()) |> to(match @front_end_url)
            end

            it "includes user info as url params" do
              expect(url()) |> to(match "last_name")
              expect(url()) |> to(match "uid")
              expect(url()) |> to(match "auth_token")
              expect(url()) |> to(match "image_url")
            end
          end

          defmodule RedirectsToFrontendWithError do
            use ESpec, shared: true

            @front_end_url Application.fetch_env!(:ueberauth, Ueberauth.Strategy.VK.OAuth)[:base_redirect_url]

            let_overridable [:url, :message]

            it "redirects to front-end" do
              expect(url()) |> to(match @front_end_url)
            end

            it "includes error message in url params" do
              expect(url()) |> to(match "Error")
              expect(url()) |> to(match message())
            end
          end

          context "when user with provided uid already exists" do
            let! :user, do: insert(:user, uid: ueberauth().extra.raw_info.user["id"] |> Integer.to_string)
            let url: success_conn() |> AuthController.callback(%{}) |> redirected_to(302)

            it_behaves_like RedirectsToFrontendWithUserInfo

            it "should not create user" do
              initial_count = entities_count(User)
              make_request()
              expect(entities_count(User)) |> to(eq(initial_count))
            end

            it "includes show_info: false" do
              expect(url()) |> to(match "show_info=false")
            end
          end

          context "when it's new user" do
            let url: success_conn() |> AuthController.callback(%{}) |> redirected_to(302)

            it_behaves_like RedirectsToFrontendWithUserInfo

            it "creates user" do
              initial_count = entities_count(User)
              make_request()
              expect(entities_count(User)) |> to(eq(initial_count + 1))
            end

            it "includes show_info: true" do
              expect(url()) |> to(match "show_info=true")
            end
          end
        end

        context "when user serch/creation failed" do
          let message: "Bad_things_happened"
          let url: success_conn() |> AuthController.callback(%{}) |> redirected_to(302)

          before do
            mock Squadster.Accounts, :find_or_create_user, {:error, message()}
          end

          it_behaves_like RedirectsToFrontendWithError
        end

        context "when there is state param included" do
          context "and when it has hash_id" do
            before do
              mock NormalizeQueue, :start_link
            end

            context "and when there is a squad with this hash_id and link invitations enabled" do
              let hash_id: "YFuzkbC6ONC4pEM3AhIBhA=="
              let url: success_conn() |> AuthController.callback(%{"state" => "hash_id=#{hash_id()}"}) |> redirected_to(302)
              let! squad: insert(:squad, hash_id: hash_id(), link_invitations_enabled: true)

              it_behaves_like RedirectsToFrontendWithUserInfo
            end

            context "and when there in no squad with such hash_id and link invitations enabled" do
              let url: success_conn() |> AuthController.callback(%{"state" => "hash_id=123"}) |> redirected_to(302)

              it_behaves_like RedirectsToFrontendWithUserInfo

              it "includes warning message that indicates that the hash_id is invalid" do
                expect(url()) |> to(match "warnings")
                expect(url()) |> to(match "Invalid+hash_id")
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
            let url: success_conn() |> AuthController.callback(%{"state" => "hello"}) |> redirected_to(302)

            it_behaves_like RedirectsToFrontendWithUserInfo

            it "includes warning message that indicates that the state is invalid" do
              expect(url()) |> to(match "warnings")
              expect(url()) |> to(match "Invalid+state")
            end
          end
        end
      end

      context "when auth failure accured" do
        let message: "No_token_provided"
        let url: failure_conn() |> AuthController.callback(%{}) |> redirected_to(302)
        let :failure_conn do
          %{build_conn() | assigns: %{ueberauth_failure: %{errors: [%{message: message()}]}}}
        end

        it_behaves_like RedirectsToFrontendWithError
      end
    end
  end

  describe "DELETE /api/auth" do
    def delete_request(conn \\ build_conn()) do
      conn |> delete(logout_path(conn, :destroy))
    end

    let user: insert(:user)

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
      expect(conn.resp_body) |> to(match "message")
    end
  end
end
