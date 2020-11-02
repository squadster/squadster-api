defmodule Squadster.Schedules.Services.UpdateLesson do
  alias Squadster.Repo
  alias Squadster.Schedules.Lesson

  def call(timetable, %{index: target_index} = args) do
    case timetable.lessons |> Enum.find(fn lesson -> lesson.index == target_index end) do
      nil -> update_single_lesson(timetable, args)
      lesson -> lesson |> update_with_swap_indexes(timetable, args)
    end
  end

  def call(timetable, args), do: update_single_lesson(timetable, args)

  defp update_with_swap_indexes(lesson_to_swap, timetable, %{current_index: current_index} = args) do
    lesson_to_swap
    |> Lesson.changeset(%{index: current_index})
    |> Repo.update

    timetable.lessons
    |> Enum.find(fn lesson -> lesson.index == current_index end)
    |> case do
      nil -> {:error, "Lesson has not found"}
      lesson -> lesson |> Lesson.changeset(args) |> Repo.update
    end
  end

  defp update_single_lesson(timetable, %{current_index: index} = args) do
    timetable.lessons
    |> Enum.find(fn lesson -> lesson.index == index end)
    |> case do
      nil -> {:error, "Lesson has not found"}
      lesson -> lesson |> Lesson.changeset(args) |> Repo.update
    end
  end
end
