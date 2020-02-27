defmodule SquadsterWeb.PingControllerTest do
  use SquadsterWeb.ConnCase

  test "GET /api/ping", %{conn: conn} do
    conn = get(conn, "/api/ping")
    assert response(conn, 200) =~ "Pong!"
  end
end
