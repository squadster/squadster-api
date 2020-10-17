defmodule SquadsterWeb.Schema.FormationTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Squadster.Formations.SquadMember

  object :squad_request do
    field :id, non_null(:id)
    field :user, :user, resolve: dataloader(Squadster.Accounts)
    field :squad, :squad, resolve: dataloader(Squadster.Formations)
    field :approver, :squad_member, resolve: dataloader(Squadster.Formations)
    field :approved_at, :datetime
    field :inserted_at, :datetime
  end

  object :squad do
    field :id, non_null(:id)
    field :hash_id, :string
    field :link_invitations_enabled, :boolean
    field :squad_number, :string
    field :advertisment, :string
    field :class_day, :integer
    field :members, list_of(:squad_member), resolve: dataloader(Squadster.Formations)
    field :requests, list_of(:squad_request), resolve: dataloader(Squadster.Formations)
  end

  object :squad_member do
    field :id, non_null(:id)
    field :role, :role
    field :queue_number, :integer
    field :user, :user, resolve: dataloader(Squadster.Accounts)
    field :squad, :squad, resolve: dataloader(Squadster.Formations)
  end

  input_object :squad_members_batch do
    field :id, non_null(:id)
    field :queue_number, :integer
  end

  scalar :role do
    parse &SquadMember.parse_role/1
    serialize &SquadMember.serialize_role/1
  end
end
