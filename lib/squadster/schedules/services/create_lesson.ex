defmodule Squadster.Schedules.Services.CreateLesson do
  alias Squadster.Repo
  alias Squadster.Schedules.Lesson

  def call(args) do
    args
    |> Lesson.changeset
    |> Repo.insert
  end
end
