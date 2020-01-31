defmodule Squadster.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :string
      add :auth_token, :string
      add :first_name, :string
      add :last_name, :string
      add :birth_date, :date
      add :mobile_phone, :string
      add :university, :string
      add :faculty, :string
      add :small_image_url, :string
      add :image_url, :string
      add :vk_url, :string
      timestamps()
    end
  end
end
