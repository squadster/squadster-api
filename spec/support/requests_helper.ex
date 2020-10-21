defmodule Squadster.Support.RequestsHelper do
  import Plug.Conn
  import Phoenix.ConnTest
  import Squadster.Support.Factory

  alias Squadster.Accounts.User

  @endpoint SquadsterWeb.Endpoint

  def login_as(%User{} = user) do
    build_conn() |> login_as(user)
  end

  def login_as(%Plug.Conn{} = conn, %User{auth_token: token}) do
    conn |> put_req_header("authorization", "Bearer " <> token)
  end

  def query(%Plug.Conn{} = conn, payload) do
    conn |> post("/api/query", payload)
  end

  def api_request(%User{} = user, payload) do
    login_as(user) |> query(payload)
  end

  def api_request(payload) do
    insert(:user) |> login_as |> query(payload)
  end
end
