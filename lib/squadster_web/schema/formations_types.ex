defmodule SquadsterWeb.Schema.FormationTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  import_types SquadsterWeb.Schema.SharedTypes

  object :squad_request do
    field :user, :user, resolve: dataloader(Squadster.Accounts)
    #field :squad, :squad
    #field :approver, :squad_member
    field :approved_at, :datetime
    field :inserted_at, :datetime
  end
end
