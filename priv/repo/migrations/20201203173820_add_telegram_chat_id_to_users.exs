defmodule Squadster.Repo.Migrations.AddTelegramChatIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :telegram_chat_id, :bigint
    end

    create unique_index(:users, :telegram_chat_id)
  end
end
