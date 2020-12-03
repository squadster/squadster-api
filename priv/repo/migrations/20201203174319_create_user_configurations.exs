defmodule Squadster.Repo.Migrations.CreateUserConfigurations do
  use Ecto.Migration

  def change do
    create table(:user_configurations) do
      add :speaker, :string
      add :language, :string
      add :rate, :string
      add :enable_voice_messages, :boolean
      add :user_id, references(:users)
    end
  end
end
