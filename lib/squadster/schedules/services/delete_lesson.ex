defmodule Squadster.Schedules.Services.DeleteLesson do
  alias Squadster.Repo

  def call(timetable, index) do
    timetable.lessons
    |> Enum.find(fn lesson -> lesson.index == index end)
    |> case do
      nil -> {:error, "There is no such lesson"}
      lesson -> Repo.delete(lesson)
    end
  end
end
