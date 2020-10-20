defmodule Squadster.Schedules do
  import Ecto.Query, only: [from: 2]

  alias Squadster.Repo
  alias Squadster.Helpers.Permissions
  alias Squadster.Formations.{Squad}
  alias Squadster.Schedules.Timetable
  alias Squadster.Schedules.Services.{
    CreateTimetable,
    UpdateTimetable
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
end
