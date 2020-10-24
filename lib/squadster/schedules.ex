defmodule Squadster.Schedules do
  import Ecto.Query, only: [from: 2]

  alias Squadster.Repo
  alias Squadster.Helpers.Permissions
  alias Squadster.Formations.{Squad}
  alias Squadster.Schedules.Timetable
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
        CreateTimetable.call(args, user, squad)
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

  def find_timetables(squad_number) do
    case Squad |> Repo.get_by(squad_number: squad_number) |> Repo.preload(:timetables) do
      %{timetables: timetables} -> {:ok, timetables}
      nil -> {:error, "There is no timetables in this squad"}
    end
  end

  def create_lesson(%{timetable_id: timetable_id} = args, user) do
    %{squad: squad} = Timetable |> Repo.get(timetable_id) |> Repo.preload(:squad)
    if user |> Permissions.can_update?(squad) do
       CreateLesson.call(args)
    else
      {:error, "Not enough permissions"}
    end
  end

  def delete_lesson(%{timetable_id: timetable_id, index: index}, user) do
    timetable = Timetable |> Repo.get(timetable_id) |> Repo.preload([:squad, :lessons])
    if user |> Permissions.can_update?(timetable.squad) do
       DeleteLesson.call(timetable, index)
    else
      {:error, "Not enough permissions"}
    end
  end

  def update_lesson(%{timetable_id: timetable_id} = args, user) do
    timetable = Timetable |> Repo.get(timetable_id) |> Repo.preload([:squad, :lessons])
    if user |> Permissions.can_update?(timetable.squad) do
      UpdateLesson.call(timetable, args)
    else
      {:error, "Not enough permissions"}
    end
  end

  def show_lessons(timetable_id, user) do
    %{squad_member: %{squad: %{squad_number: user_squad_number}}} =
      user
      |> Repo.preload(squad_member: :squad)
    timetable =
      Timetable
      |> Repo.get(timetable_id)
      |> Repo.preload([:squad, :lessons])

    if user_squad_number == timetable.squad.squad_number do
      {:ok, timetable.lessons}
    else
      {:error, "Permission denied"}
    end
  end
end
