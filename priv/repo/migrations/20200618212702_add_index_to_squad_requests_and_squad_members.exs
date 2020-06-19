defmodule Squadster.Repo.Migrations.AddIndexToSquadRequestsAndSquadMembers do
  use Ecto.Migration

  def change do
    create unique_index(:squad_requests, [:squad_id, :user_id])
    create unique_index(:squad_members,  [:squad_id, :user_id])
  end
end
