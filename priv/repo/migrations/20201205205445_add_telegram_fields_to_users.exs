defmodule Squadster.Repo.Migrations.AddTelegramFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :telegram_chat_id, :bigint
      add :telegram_id, :bigint
      add :telegram_token, :string
    end

    create unique_index(:users, :telegram_chat_id)
  end
end
