defmodule SquadsterWeb.UserController do
  use SquadsterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def edit(conn, _params) do
    render(conn, "edit.html")
  end
end
