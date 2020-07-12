defmodule Squadster.Repo.Migrations.AddLessons do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add :name, :string
      add :teacher, :string
      add :index_number, :integer
      add :note, :string
      add :timetable_id, references(:timetables, on_delete: :delete_all)

      timestamps()
    end
  end
end
