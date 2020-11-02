defmodule Squadster.Schedules.Services.UpdateTimetable do
  alias Squadster.Repo
  alias Squadster.Schedules.Timetable

  def call(args, timetable) do
    timetable
    |> Timetable.changeset(args)
    |> Repo.update
  end
end
