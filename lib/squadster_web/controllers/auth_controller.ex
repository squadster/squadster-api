defmodule SquadsterWeb.AuthController do
  use SquadsterWeb, :controller

  import Mockery.Macro

  plug Ueberauth when action not in [:destroy]
  plug SquadsterWeb.Plugs.Auth when action in [:destroy]

  alias Squadster.Accounts
  alias Squadster.Formations

  @base_redirect_url Application.fetch_env!(:ueberauth, Ueberauth.Strategy.VK.OAuth)[:base_redirect_url]

  def destroy(conn, _params) do
    Accounts.logout(conn)
    conn
    |> put_status(:ok)
    |> json(%{message: "Logged out"})
  end

  def callback(%{assigns: %{ueberauth_failure: %{errors: [%{message: reason}]}}} = conn, _params) do
    send_auth_error(conn, reason)
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    case mockable(Accounts).find_or_create_user(auth) do
      {:ok, user} ->
        warnings = case create_squad_member(params["state"], user) do
                     {:ok, _member} -> []
                     {:error, message} -> [message]
                   end
        redirect(conn, external: redirect_url(user: user, warnings: warnings))
      {:error, reason} -> send_auth_error(conn, reason)
    end
  end

  defp send_auth_error(conn, reason) do
    redirect(conn, external: redirect_url(error: reason))
  end

  defp redirect_url(error: reason) do
    @base_redirect_url <> URI.encode_query(%{message: "Error", reason: reason})
  end

  defp redirect_url(user: user, warnings: warnings) do
    user_data = Map.take(user, Accounts.User.user_fields)
    @base_redirect_url <> URI.encode_query(%{
      message: "Logged in",
      warnings: Poison.encode(warnings) |> elem(1),
      user: Poison.encode(user_data) |> elem(1)
    })
  end

  defp create_squad_member("hash_id=" <> hash_id, user) do
    squad = Formations.find_squad_by_hash_id(hash_id)
    if squad do
      user |> Formations.create_squad_member(squad)
    else
      {:error, "Invalid hash_id"}
    end
  end

  defp create_squad_member(nil, _), do: {:ok, nil}
  defp create_squad_member(_, _), do: {:error, "Invalid state"}
end
