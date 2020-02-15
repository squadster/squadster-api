defmodule Squadster.Repo.Migrations.CreateSquadMembers do
  use Ecto.Migration

  def change do
    create table(:squad_members) do
      add :role, :int, default: 3
      add :queue_number, :int
      add :user_id, references(:users)
      add :squad_id, references(:squads)

      timestamps()
    end
  end
end
