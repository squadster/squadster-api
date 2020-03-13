defmodule Squadster.Workers.NotifyAttendants do
  use Task

  import Ecto.Query
  import HTTPoison

  alias Squadster.Formations.SquadMember
  alias Squadster.Repo

  @bot_endpoint "https://mercury-dev.herokuapp.com/message"
  @message "Завтра вы ответственный за лопату!"
  @request_headers [{"content-type", "application/json"}]

  def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
  end

  def run(_args) do
    next_day_duties = from(member in SquadMember, where: member.queue_number == 1)
    |> Repo.all
    |> Repo.preload(:user)
    |> Enum.each fn duty ->
      notify(duty.user)
    end
  end

  defp notify(duty) do
    HTTPoison.post @bot_endpoint, request_body(duty.id), @request_headers
  end

  def request_body(duty_id) do
    """
      {
        "text": "#{@message}",
        "targer": #{duty_id}
      }
    """
  end
end
