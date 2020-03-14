defmodule Squadster.Workers.NotifyAttendants do
  use Task

  import Ecto.Query
  import HTTPoison

  alias Squadster.Repo
  alias Squadster.Helpers.Dates
  alias Squadster.Formations.{Squad, SquadMember}

  @bot_endpoint Application.fetch_env!(:squadster, :bot_url) <> "/message"
  @message "Завтра вы ответственный за лопату!"
  @request_headers [{"content-type", "application/json"}]

  def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
  end

  def run(_args) do
    tomorrow = Dates.tomorrow |> Dates.day_of_a_week
    from(squad in Squad, where: squad.class_day == ^tomorrow)
    |> Repo.all
    |> Repo.preload(members: :user)
    |> Enum.each fn %{members: members} ->
      members
      |> Enum.filter(fn member -> member.queue_number == 1 end)
      |> Enum.each(&notify/1)
    end
  end

  defp notify(%{user: user}) do
    HTTPoison.post @bot_endpoint, request_body(user), @request_headers
  end

  def request_body(user) do
    """
      {
        "text": "#{@message}",
        "target": #{user.id}
      }
    """
  end
end
