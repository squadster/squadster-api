defmodule Squadster.Schedules.Services.DeleteLesson do
  alias Squadster.Repo

  def call(lesson) do
    lesson
    |> Repo.delete
  end
end
