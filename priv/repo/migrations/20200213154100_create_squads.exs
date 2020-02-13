defmodule Squadster.Repo.Migrations.CreateSquads do
  use Ecto.Migration

  def change do
    create table(:squads) do
      add :squad_number, :string
      add :advertisment, :text

      timestamps()
    end
  end
end
