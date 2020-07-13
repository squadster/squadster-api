defmodule Squadster.Repo.Migrations.AddTimetables do
  use Ecto.Migration

  def change do
    create table(:timetables) do
      add :date, :date
      add :squad_id, references(:squads, on_delete: :delete_all)

      timestamps()
    end
  end
end
