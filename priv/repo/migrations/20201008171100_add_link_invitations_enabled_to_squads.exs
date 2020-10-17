defmodule Squadster.Repo.Migrations.AddLinkInvitationsEnabledToSquads do
  use Ecto.Migration

  def change do
    alter table(:squads) do
      add :link_invitations_enabled, :boolean, default: false
    end
  end
end
