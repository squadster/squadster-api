defmodule Squadster.Web.Plugs.ContextSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  import Mockery
  import Mockery.Assertions

  alias SquadsterWeb.Plugs.Context
  alias SquadsterWeb.Plugs.Auth

  describe "call/2" do
    context "when the method is POST" do
      before do
        mock Auth, :call, authorized_conn()
      end

      let :authorized_conn, do: %Plug.Conn{build_conn() | assigns: %{current_user: user()}}
      let :post_conn, do: %Plug.Conn{build_conn() | method: "POST"}
      let :user, do: insert(:user)

      it "should call Auth.call/2" do
        post_conn() |> Context.call([])
        assert_called Auth, :call
      end

      it "should assign current_user to absinthe context" do
        conn = post_conn() |> Context.call([])
        expect conn.private.absinthe.context.current_user |> to(eq user())
      end
    end

    context "when the method is other than POST" do
      it "should return an initial conn" do
        initial_conn = %Plug.Conn{build_conn() | method: "GET"}
        conn = initial_conn |> Context.call([])
        expect conn |> to(eq initial_conn)
      end
    end
  end
end
