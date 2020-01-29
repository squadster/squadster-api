defmodule SquadsterWeb.SessionController do
  use SquadsterWeb, :controller

  plug Ueberauth when action not in [:destroy]
  plug SquadsterWeb.Plugs.Auth when action in [:destroy]

  alias Squadster.User

  @base_redirect_url System.get_env("FRONTEND_URL") <> "/auth_callback"

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
        redirect(conn, external: redirect_url(token: user.auth_token))
      {:error, reason} -> send_auth_error(conn, reason)
    end
  end

  defp send_auth_error(conn, reason) do
    redirect(conn, external: redirect_url(error: reason))
  end

  defp redirect_url(error: reason) do
    @base_redirect_url <> "?message=error&reason=#{reason}"
  end

  defp redirect_url(token: token) do
    @base_redirect_url <> "&message=logged_in&token=#{token}"
  end
end
