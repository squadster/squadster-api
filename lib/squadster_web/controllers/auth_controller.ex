defmodule SquadsterWeb.AuthController do
  use SquadsterWeb, :controller

  plug Ueberauth when action not in [:destroy]
  plug SquadsterWeb.Plugs.Auth when action in [:destroy]

  alias Squadster.Accounts

  @base_redirect_url Application.fetch_env!(:ueberauth, Ueberauth.Strategy.VK.OAuth)[:base_redirect_url]

  def destroy(conn, _params) do
    Accounts.logout(conn)
    conn
    |> put_status(:ok)
    |> json(%{message: "Logged out"})
  end

  def callback(%{assigns: %{ueberauth_failure: reason}} = conn, _params) do
    send_auth_error(conn, reason)
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.find_or_create_user(auth) do
      {:ok, user} -> redirect(conn, external: redirect_url(user: user))
      {:error, reason} -> send_auth_error(conn, reason)
    end
  end

  defp send_auth_error(conn, reason) do
    redirect(conn, external: redirect_url(error: reason))
  end

  defp redirect_url(error: reason) do
    @base_redirect_url <> URI.encode_query(%{message: "Error", reason: reason})
  end

  defp redirect_url(user: user) do
    user_data = Map.take(user, Accounts.User.user_fields)
    @base_redirect_url <> URI.encode_query(%{message: "Logged in", user: Poison.encode(user_data) |> elem(1) })
  end
end
