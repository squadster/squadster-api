defmodule Squadster.Schedules.Services.CreateLesson do
  alias Squadster.Repo
  alias Squadster.Schedules.Lesson

  def call(timetable, %{index: index} = args) do
    timetable.lessons
    |> Enum.find(fn lesson -> lesson.index == index end)
    |> case do
      nil -> create(args)
      _lesson -> {:error, "Lesson with index #{index} already exists"}
    end
  end

  def call(timetable, args), do: create(Map.merge(args, %{index: get_last_index(timetable.lessons)}))

  defp get_last_index(lessons) do
    (lessons |> Enum.map(fn el -> el.index end) |> Enum.sort |> List.last) + 1
  end

  defp create(args) do
    args
    |> Lesson.changeset
    |> Repo.insert
  end
end
