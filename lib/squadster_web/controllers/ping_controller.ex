defmodule SquadsterWeb.PingController do
  use SquadsterWeb, :controller

  def ping(conn, _params) do
    send_resp(conn, 200, "Pong!")
  end
end
