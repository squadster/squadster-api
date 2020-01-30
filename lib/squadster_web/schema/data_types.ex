defmodule SquadsterWeb.Schema.DataTypes do
  use Absinthe.Schema.Notation

  alias Squadster.DateHelper

  object :user do
    field :id, non_null(:id)
    field :uid, non_null(:string)
    field :vk_url, non_null(:string)
    field :image_url, :string
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :birth_date, :date
    field :email, :string
    field :mobile_phone, :string
    field :university, :string
    field :faculty, :string
  end

  scalar :date do
    parse &DateHelper.date_from_string/1
    serialize &DateHelper.date_to_string/1
  end
end
