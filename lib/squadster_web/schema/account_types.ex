defmodule SquadsterWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  alias Squadster.Helpers.Dates

  object :user do
    field :id, non_null(:id)
    field :uid, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :birth_date, :date
    field :email, :string
    field :mobile_phone, :string
    field :university, :string
    field :faculty, :string
    field :small_image_url, :string
    field :image_url, :string
  end

  scalar :date do
    parse &Dates.date_from_string/1
    serialize &Dates.date_to_string/1
  end
end
