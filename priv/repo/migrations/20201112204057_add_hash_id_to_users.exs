defmodule Squadster.Repo.Migrations.AddHashIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :hash_id, :string
    end

    create unique_index(:users, :hash_id)
  end
end
