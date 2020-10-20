defmodule Squadster.Schedules.Services.CreateTimetable do
  alias Squadster.Repo
  alias Squadster.Formations.{Squad}
  alias Squadster.Schedules.Timetable

  def call(args, user, squad) do
    squad
    |> Repo.preload(:timetables)
    |> case do
      %{timetables: []} -> create(args, user)
      %{timetables: _timetables} -> {:error, "Squad already has timetable"}
    end
  end

  defp create(args, user) do
    args
    |> Timetable.changeset
    |> Repo.insert
  end
end
