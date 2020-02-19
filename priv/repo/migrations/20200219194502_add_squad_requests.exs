defmodule Squadster.Repo.Migrations.AddSquadRequests do
  use Ecto.Migration

  def change do
    create table(:squad_requests) do
      add :approver_id, references(:users)
      add :user_id, references(:users)
      add :squad_id, references(:squads)
      add :approved_at, :timestamp

      timestamps()
    end
  end
end
