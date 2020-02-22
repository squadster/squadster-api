defmodule SquadsterWeb.Schema.FormationTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :squad_request do
    field :user, :user, resolve: dataloader(Squadster.Accounts)
    field :squad, :squad, resolve: dataloader(Squadster.Formations)
    field :approver, :squad_member, resolve: dataloader(Squadster.Formations)
    field :approved_at, :datetime
    field :inserted_at, :datetime
  end

  object :squad do
    field :squad_number, :string
    field :advertisment, :string
    field :class_day, :integer
    field :members, list_of(:squad_member), resolve: dataloader(Squadster.Formations)
    field :requests, list_of(:squad_request), resolve: dataloader(Squadster.Formations)
  end

  object :squad_member do
    field :role, :integer
    field :queue_number, :integer
    field :user, :user, resolve: dataloader(Squadster.Accounts)
    field :squad, :squad, resolve: dataloader(Squadster.Formations)
  end
end
