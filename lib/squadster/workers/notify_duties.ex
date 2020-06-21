defmodule Squadster.Workers.NotifyDuties do
  use Task

  import Ecto.Query
  import SquadsterWeb.Gettext

  alias Squadster.Repo
  alias Squadster.Helpers.Dates
  alias Squadster.Formations.Squad

  def start_link do
    Task.start_link(__MODULE__, :run, [])
  end

  def run do
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
    gettext("You are on duty tomorrow!") |> Squadster.Helpers.Messages.send_to(user)
  end
end
