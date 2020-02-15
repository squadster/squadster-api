defmodule Squadster.Repo.Migrations.CreateSquads do
  use Ecto.Migration

  def change do
    create table(:squads) do
      add :squad_number, :string
      add :advertisment, :text
      add :class_day, :int

      timestamps()
    end
  end
end
