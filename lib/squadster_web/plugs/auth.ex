defmodule SquadsterWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias Squadster.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    unless token = Enum.at(get_req_header(conn, "authorization"), 0) do
      send_auth_error(conn, "Authorization token not provided")
    end

    if current_user = Accounts.find_user_by_token(token) do
      assign(conn, :current_user, current_user)
    else
      send_auth_error(conn, "Authorization token is invalid")
    end
  end

  defp send_auth_error(conn, reason) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: reason, message: "Failed to authenticate"})
    |> halt()
  end
end
