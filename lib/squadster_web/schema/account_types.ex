defmodule SquadsterWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :user do
    field :id, non_null(:id)
    field :uid, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :birth_date, :date
    field :mobile_phone, :string
    field :university, :string
    field :faculty, :string
    field :small_image_url, :string
    field :image_url, :string
    field :vk_url, :string
    field :squad_request, :squad_request, resolve: dataloader(Squadster.Formations)
    field :squad_member, :squad_member, resolve: dataloader(Squadster.Formations)
  end
end
