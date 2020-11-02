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

  def create_lesson(_parent, args, %{context: %{current_user: user}}) do
    mockable(Schedules).create_lesson(args, user)
  end

  def create_lesson(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def delete_lesson(_parent, args, %{context: %{current_user: user}}) do
    mockable(Schedules).delete_lesson(args, user)
  end

  def delete_lesson(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def update_lesson(_parent, args, %{context: %{current_user: user}}) do
    mockable(Schedules).update_lesson(args, user)
  end

  def update_lesson(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
