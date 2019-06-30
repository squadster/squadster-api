defmodule SquadsterWeb.SessionController do
  use SquadsterWeb, :controller
  plug Ueberauth
  alias Ueberauth.Strategy.Helpers


  # def new(conn, _params) do
  #   render conn, "new.html"
  # end

  # def create(_conn, _params) do
  #   # user = User.find_or_create_from_omniauth(request.env["omniauth.auth"])
  #   # session[:user_id] = user.id
  #   # redirect_to user_path(user), notice: "Signed in!"
  # end

  # def destroy(_conn, _params) do
  #   # session[:user_id] = nil
  #   # redirect_to root_url, alert: "Signed out!"
  # end
  #
  # def failure_callback(conn, _params), do: redirect(conn, to: Routes.root_path(conn, :new))



  def request(conn, _params) do
    render(conn, "new.html", callback_url: Helpers.callback_url(conn))
  end

  def destroy(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

end
