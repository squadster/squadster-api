defmodule Squadster.User do
  use Ecto.Schema

  schema "users" do
    field :uid, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :birth_date, :date
    field :mobile_phone, :string
    field :university, :string
    field :faculty, :string
    field :vk_url, :string
    field :image_url, :string
    timestamps()
  end
end
