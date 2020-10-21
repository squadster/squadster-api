defmodule Squadster.Schema do
  use Absinthe.Schema

  alias SquadsterWeb.Resolvers.Accounts, as: AccountsResolver
  alias SquadsterWeb.Resolvers.Formations, as: FormationsResolver
  alias Squadster.{Accounts, Formations}

  import_types SquadsterWeb.Schema.{SharedTypes, AccountTypes, FormationTypes}

  query do
    @desc "Get a list of users"
    field :users, list_of(:user) do
      resolve &AccountsResolver.users/3
    end

    @desc "Find a user by id"
    field :user, :user do
      arg :id, non_null(:id)

      resolve &AccountsResolver.user/3
    end

    @desc "Get current user"
    field :current_user, :user do
      resolve &AccountsResolver.current_user/3
    end

    @desc "Get a list of squads"
    field :squads, list_of(:squad) do
      resolve &FormationsResolver.squads/3
    end

    @desc "Get a squad by number"
    field :squad, :squad do
      arg :squad_number, non_null(:string)

      resolve &FormationsResolver.squad/3
    end
  end

  mutation do
    @desc "Update user"
    field :update_user, type: :user do
      arg :first_name, :string
      arg :last_name, :string
      arg :birth_date, :date
      arg :mobile_phone, :string
      arg :university, :string
      arg :faculty, :string

      resolve &AccountsResolver.update_user/3
    end

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

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Accounts, Accounts.data())
      |> Dataloader.add_source(Formations, Formations.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
