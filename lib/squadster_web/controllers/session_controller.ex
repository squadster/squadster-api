defmodule SquadsterWeb.SessionController do
  use SquadsterWeb, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Squadster.User

  def destroy(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> send_resp(200, %{info: "logged out"})
  end

  def callback(%{assigns: %{ueberauth_failure: reason}} = conn, _params) do
    send_resp(conn, 401, %{error: reason})
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case User.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> send_resp(200, %{info: "logged in", token: user.auth_token})
      {:error, reason} -> send_resp(conn, 401, %{error: reason})
    end
  end
end
