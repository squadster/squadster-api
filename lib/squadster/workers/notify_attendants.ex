defmodule Squadster.Workers.NotifyAttendants do
  use Task

  import Ecto.Query
  import SquadsterWeb.Gettext

  alias Squadster.Repo
  alias Squadster.Helpers.Dates
  alias Squadster.Formations.Squad

  @bot_endpoint Application.fetch_env!(:squadster, :bot_url) <> "/message"
  @bot_token "ApiKey " <> Application.fetch_env!(:squadster, :bot_token)
  @request_headers [{"content-type", "application/json"}, {"Authorization", @bot_token}]

  def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
  end

  def run(_args) do
    tomorrow = Dates.tomorrow |> Dates.day_of_a_week
    from(squad in Squad, where: squad.class_day == ^tomorrow)
    |> Repo.all
    |> Repo.preload(members: :user)
    |> Enum.each(fn %{members: members} ->
      members
      |> Enum.filter(fn member -> member.queue_number == 1 end)
      |> Enum.each(&notify/1)
    end)
  end

  defp notify(%{user: user}) do
    HTTPoison.post @bot_endpoint, request_body(user), @request_headers
  end

  defp request_body(user) do
    """
      {
        "text": "#{gettext("You are on duty tomorrow!")}",
        "target": #{user.uid},
        "types": ["text", "voice"]
      }
    """
  end
end
