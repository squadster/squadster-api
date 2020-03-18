defmodule Squadster.Web.PingControllerSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  describe "GET /api/ping" do
    let :response do
      build_conn() |> get("/api/ping")
    end

    it "pings!" do
      expect response().resp_body |> to(match(~r/Pong!/))
    end
  end
end
