defmodule Squadster.PingControllerSpec do
  use ESpec.Phoenix, controller: PingController, async: true

  describe "GET /api/ping" do
    let :response do
      build_conn() |> get("/api/ping")
    end

    it "pings!" do
      expect(response().resp_body).to match(~r/Pong!/)
    end
  end
end
