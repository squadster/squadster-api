defmodule SquadsterWeb.SessionController do
  use SquadsterWeb, :controller

  def new(conn, _params) do
    render conn, "new.html", conn: conn
  end

  def create(conn, _params) do
    # user = User.find_or_create_from_omniauth(request.env["omniauth.auth"])
    # session[:user_id] = user.id
    # redirect_to user_path(user), notice: "Signed in!"
  end

  def destroy(conn, _params) do
    # session[:user_id] = nil
    # redirect_to root_url, alert: "Signed out!"
  end

  def failure_callback(conn, _params), do: redirect(conn, to: Routes.root_path(conn, :new))
end
