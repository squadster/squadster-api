defmodule Squadster.Schema.DataTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :uid, :string
    field :vk_url, :string
    field :image_url, :string
    field :first_name, :string
    field :last_name, :string
    #field :birth_date, :date
    field :email, :string
    field :mobile_phone, :string
    field :university, :string
    field :faculty, :string
  end
end
