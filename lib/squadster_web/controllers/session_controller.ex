defmodule SquadsterWeb.SessionController do
  use SquadsterWeb, :controller

  plug Ueberauth when action not in [:destroy]
  plug SquadsterWeb.Plugs.Auth when action in [:destroy]

  alias Squadster.User

  def destroy(conn, _params) do
    User.logout(conn)
    conn
    |> put_status(:ok)
    |> json(%{message: "Logged out"})
  end

  def callback(%{assigns: %{ueberauth_failure: reason}} = conn, _params) do
    send_auth_error(conn, reason)
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case User.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Logged in", token: user.auth_token})
      {:error, reason} -> send_auth_error(conn, reason)
    end
  end

  defp send_auth_error(conn, reason) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: reason, message: "Failed to authenticate"})
  end
end
