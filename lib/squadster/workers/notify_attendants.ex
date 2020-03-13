defmodule Squadster.Workers.NotifyAttendants do
  use Task

  @bot_endpoint "https://mercury-dev.herokuapp.com/message"
  # request_example: HTTPoison.post "https://mercury-dev.herokuapp.com/message", "{\"text\": \"FUCK YOU YOU FUCKING FUCK\", \"target\": 1488}", [{"content-type", "application/json"}]

  def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
  end

  def run(_args) do
    # TODO: implement
  end
end
