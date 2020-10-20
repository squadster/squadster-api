defmodule SquadsterWeb.Resolvers.Schedules do
  alias Squadster.Schedules

  import Mockery.Macro

  def create_timetable(_parent, args, %{context: %{current_user: user}}) do
    mockable(Schedules).create_timetable(args, user)
  end

  def create_timetable(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def delete_timetable(_parent, %{timetable_id: id}, %{context: %{current_user: user}}) do
    mockable(Schedules).delete_timetable(id, user)
  end

  def delete_timetable(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def update_timetable(_parent, args, %{context: %{current_user: user}}) do
    mockable(Schedules).update_timetable(args, user)
  end

  def update_timetable(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def find_timetables(_parent, %{squad_number: number}, %{context: %{current_user: user}}) do
    Schedules.find_timetables(number)
  end

  def find_timetables(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
