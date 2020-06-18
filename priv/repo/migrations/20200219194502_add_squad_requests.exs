defmodule Squadster.Repo.Migrations.AddSquadRequests do
  use Ecto.Migration

  def change do
    create table(:squad_requests) do
      add :approver_id, references(:squad_members, on_delete: :nilify_all)
      add :user_id, references(:users)
      add :squad_id, references(:squads, on_delete: :delete_all)
      add :approved_at, :timestamp

      timestamps()
    end
  end
end
