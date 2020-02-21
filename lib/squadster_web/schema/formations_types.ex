defmodule SquadsterWeb.Schema.FormationTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :squad_request do
    field :user, :user, resolve: dataloader(Squadster.Accounts)
    #field :squad, :squad
    #field :approver, :squad_member
    #field :approved_at, :date
    #
    #timestamps()
  end

  #scalar :date do
    #parse &Dates.date_from_string/1
    #serialize &Dates.date_to_string/1
  #end
end
