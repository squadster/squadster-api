defmodule Squadster.Formations.Services.UpdateSquad do
  import Mockery.Macro

  alias Squadster.Repo
  alias Ecto.Multi
  alias Squadster.Formations.Squad
  alias Squadster.Schedules.Timetable
  alias Squadster.Formations.Services.NotifySquadChanges

  def call(squad, args, user) do
    changeset = squad |> Squad.changeset(args)

    case changeset |> Repo.update do
      {:ok, squad} ->
        unless is_nil(changeset.changes[:class_day]) do
          squad |> update_timetable_dates(changeset)
        end

        changeset.changes |> mockable(NotifySquadChanges).call(squad, user)
        {:ok, squad}
      {:error, reason} -> {:error, reason}
    end
  end

  defp update_timetable_dates(squad, changeset) do
    %{timetables: timetables} = squad |> Repo.preload(:timetables)

    timetables
    |> Enum.reduce(Multi.new(), fn timetable, batch ->
      batch |> Multi.update(
        timetable.id,
        timetable |> Timetable.changeset(%{date: timetable.date |> Timex.shift(days: dates_difference(changeset))})
      )
    end)
    |> Repo.transaction
  end

  defp dates_difference(%{data: %{class_day: current_day}, changes: %{class_day: new_day}}) do
    current_day_number = current_day |> Squad.class_day_number
    new_day_number = new_day |> Squad.class_day_number
    new_day_number - current_day_number
  end
end
