defmodule SquadsterWeb.PageController do
  use SquadsterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
