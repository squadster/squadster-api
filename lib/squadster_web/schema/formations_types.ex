defmodule SquadsterWeb.Schema.FormationTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Squadster.Formations.SquadMember
  alias SquadsterWeb.Resolvers.Formations, as: FormationsResolver

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
    field :hash_id, non_null(:string)
    field :link_invitations_enabled, :boolean
    field :squad_number, :string
    field :advertisment, :string
    field :class_day, :integer
    field :members, list_of(:squad_member), resolve: dataloader(Squadster.Formations)
    field :timetables, list_of(:timetable), resolve: dataloader(Squadster.Schedules)
    field :requests, list_of(:squad_request), resolve: dataloader(Squadster.Formations)
  end

  object :squad_member do
    field :id, non_null(:id)
    field :role, :role
    field :queue_number, :integer
    field :user, :user, resolve: dataloader(Squadster.Accounts)
    field :squad, :squad, resolve: dataloader(Squadster.Formations)
  end

  object :formations_queries do
    # TODO: rebuild permissions
    @desc "Get a list of squads"
    field :squads, list_of(:squad) do
      resolve &FormationsResolver.squads/3
    end
  end

  object :formations_mutations do
    @desc "Create a squad"
    field :create_squad, type: :squad do
      arg :squad_number, non_null(:string)
      arg :advertisment, :string
      arg :class_day, non_null(:integer)
      arg :link_invitations_enabled, :boolean

      resolve &FormationsResolver.create_squad/3
    end

    @desc "Update a squad"
    field :update_squad, type: :squad do
      arg :id, non_null(:id)
      arg :squad_number, :string
      arg :advertisment, :string
      arg :class_day, :integer
      arg :link_invitations_enabled, :boolean

      resolve &FormationsResolver.update_squad/3
    end

    @desc "Delete a squad"
    field :delete_squad, type: :squad do
      arg :id, non_null(:id)

      resolve &FormationsResolver.delete_squad/3
    end

    @desc "Create a squad_request"
    field :create_squad_request, type: :squad_request do
      arg :squad_id, non_null(:id)

      resolve &FormationsResolver.create_squad_request/3
    end

    @desc "Approve a squad_request"
    field :approve_squad_request, type: :squad_member do
      arg :id, non_null(:id)

      resolve &FormationsResolver.approve_squad_request/3
    end

    @desc "Delete/decline a squad_request"
    field :delete_squad_request, type: :squad_request do
      arg :id, non_null(:id)

      resolve &FormationsResolver.delete_squad_request/3
    end

    @desc "Update a squad_member"
    field :update_squad_member, type: :squad_member do
      arg :id, non_null(:id)
      arg :queue_number, :integer
      arg :role, :string

      resolve &FormationsResolver.update_squad_member/3
    end

    @desc "Update a batch of squad_members"
    field :update_squad_members, type: list_of(:squad_member) do
      arg :batch, list_of(:squad_members_batch)

      resolve &FormationsResolver.update_squad_members/3
    end

    @desc "Delete a squad_member"
    field :delete_squad_member, type: :squad_member do
      arg :id, non_null(:id)

      resolve &FormationsResolver.delete_squad_member/3
    end
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
