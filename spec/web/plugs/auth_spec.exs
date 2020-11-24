defmodule Squadster.Web.Plugs.AuthSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  alias SquadsterWeb.Plugs.Auth

  describe "call/2" do
    context "when no token provided" do
      it "should be unauthorized" do
        conn = build_conn() |> Auth.call([])
        expect conn.status |> to(eq 401)
      end
    end

    context "when token is provided" do
      context "and it is not prepended with 'Bearer' type" do
        it "should be unauthorized" do
          conn = build_conn()
                 |> put_req_header("authorization", "token")
                 |> Auth.call([])

          expect conn.status |> to(eq 401)
        end
      end

      context "and it is prepended with correct type" do
        context "and there are no user with such token" do
          it "should be unauthorized" do
            conn = build_conn()
                   |> put_req_header("authorization", "Bearer token")
                   |> Auth.call([])

            expect conn.status |> to(eq 401)
          end
        end

        context "and there is a user with such token" do
          let :user, do: insert(:user)

          it "should assign current_user" do
            conn = build_conn()
                   |> put_req_header("authorization", "Bearer " <> user().auth_token)
                   |> Auth.call([])

            expect conn.assigns.current_user.id |> to(eq user().id)
          end
        end
      end
    end
  end
end
