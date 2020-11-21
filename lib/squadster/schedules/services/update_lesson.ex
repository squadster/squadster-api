defmodule Squadster.Schedules.Services.UpdateLesson do
  alias Ecto.Multi
  alias Squadster.Repo
  alias Squadster.Schedules.Lesson

  def call(lessons, args) when is_list(lessons) do
    lessons
    |> Enum.reduce(Multi.new(), fn lesson, batch ->
      data = lesson_changes(args, lesson.id)
      batch |> Multi.update(
        lesson.id,
        lesson |> Lesson.changeset(data)
      )
    end)
    |> Repo.transaction
  end

  def call(lesson, args) do
    lesson
    |> Lesson.changeset(args)
    |> Repo.update
  end

  defp lesson_changes(args, id) do
    Enum.find(args, fn arg -> String.to_integer(arg[:id]) == id end)
  end
end
