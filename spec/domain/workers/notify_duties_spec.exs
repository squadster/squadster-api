# TODO: Check, if worker send correct data to bot
defmodule Squadster.Workers.NotifyDutiesSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :worker

  it "Sends request to bot with valid params" do
    # expect HTTPoison |> to(receivce :valid_params)
  end
end
