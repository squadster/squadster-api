defmodule Squadster.Schedules do
  import Ecto.Query, only: [from: 2]

  alias Squadster.Repo
  alias Squadster.Helpers.Permissions
  alias Squadster.Formations.{Squad}
  alias Squadster.Schedules.{Timetable, Lesson}
  alias Squadster.Schedules.Services.{
    CreateTimetable,
    UpdateTimetable,
    CreateLesson,
    DeleteLesson,
    UpdateLesson
  }

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params), do: queryable

  def create_timetable(%{squad_id: id} = args, user) do
    with squad <- Squad |> Repo.get(id) do
      if user |> Permissions.can_update?(squad) do
        CreateTimetable.call(args)
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def delete_timetable(id, user) do
    timetable = Timetable |> Repo.get(id) |> Repo.preload(:squad)
    with squad <- timetable.squad do
      if user |> Permissions.can_delete?(squad) do
        timetable |> Repo.delete
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def update_timetable(%{timetable_id: id} = args, user) do
    case Timetable |> Repo.get(id) |> Repo.preload(:squad) do
      nil -> {:error, "There is no such timetable"}
      timetable ->
        with squad <- timetable.squad do
          if user |> Permissions.can_update?(squad) do
            UpdateTimetable.call(args, timetable)
          else
            {:error, "Not enough permissions"}
          end
        end
    end
  end

  def create_lesson(%{timetable_id: timetable_id} = args, user) do
    timetable = Timetable |> Repo.get(timetable_id) |> Repo.preload([:squad, :lessons])
    if user |> Permissions.can_update?(timetable.squad) do
       CreateLesson.call(timetable, args)
    else
      {:error, "Not enough permissions"}
    end
  end

  def delete_lesson(id, user) do
    lesson = Lesson |> Repo.get(id) |> Repo.preload(timetable: :squad)
    if user |> Permissions.can_update?(lesson.timetable.squad) do
       DeleteLesson.call(lesson)
    else
      {:error, "Not enough permissions"}
    end
  end

  def update_lesson(%{id: id} = args, user) do
    lesson = Lesson |> Repo.get(id) |> Repo.preload(timetable: :squad)
    if user |> Permissions.can_update?(lesson.timetable.squad) do
      UpdateLesson.call(lesson, args)
    else
      {:error, "Not enough permissions"}
    end
  end

  def bulk_update_lessons(args, user) do
    lessons =
      Enum.map(args, fn data -> data[:id] end)
      |> all_lessons

    %{timetable: %{squad: squad}} = lessons |> List.first |> Repo.preload(timetable: :squad)

    if user |> Permissions.can_update?(squad) do
      lessons |> UpdateLesson.call(args)
    else
      {:error, "Not enough permissions"}
    end
  end

  def all_lessons(ids) do
    from(
      lesson in Lesson,
      where: lesson.id in ^ids
    )
    |> Repo.all
  end
end
