defmodule Squadster.Schedules.Services.DeleteLesson do
  import Ecto.Query, only: [from: 2]

  alias Squadster.Repo
  alias Squadster.Schedules.Lesson

  def call(timetable, index) do
    timetable.lessons
    |> Enum.find(fn lesson -> lesson.index == index end)
    |> case do
      nil -> {:error, "There is no such lesson"}
      lesson -> Repo.delete(lesson)
    end
  end
end
