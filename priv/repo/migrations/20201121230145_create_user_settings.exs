defmodule Squadster.Repo.Migrations.CreateUserSettings do
  use Ecto.Migration

  def change do
    create table(:user_settings) do
      add :vk_notifications_enabled, :boolean, default: true
      add :telegram_notifications_enabled, :boolean, default: false
      add :email_notifications_enabled, :boolean, default: false
      add :user_id, references(:users)
    end
  end
end
