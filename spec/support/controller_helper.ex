defmodule Squadster.Support.RequestsHelper do
  use Phoenix.ConnTest

  alias Squadster.Accounts.User

  @endpoint SquadsterWeb.Endpoint

  def login_as(conn, %User{auth_token: token}) do
    conn |> put_req_header("authorization", "Bearer " <> token)
  end

  def login_as(%User{auth_token: token}) do
    build_conn() |> put_req_header("authorization", "Bearer " <> token)
  end

  def query(conn, payload) do
    conn |> post("/api/query", payload)
  end
end
