defmodule Squadster.Schema do
  use Absinthe.Schema

  alias SquadsterWeb.Resolvers.Accounts, as: AccountsResolver
  alias SquadsterWeb.Resolvers.Formations, as: FormationsResolver
  alias Squadster.{Accounts, Formations}

  import_types SquadsterWeb.Schema.{SharedTypes, AccountTypes, FormationTypes}

  query do
    @desc "Get a list of users"
    field :users, list_of(:user) do
      resolve &AccountsResolver.list_users/3
    end

    @desc "Find a user by id"
    field :user, :user do
      arg :id, non_null(:id)

      resolve &AccountsResolver.find_user/3
    end

    @desc "Get current user"
    field :current_user, :user do
      resolve &AccountsResolver.current_user/3
    end

    @desc "Get a list of squads"
    field :squads, list_of(:squad) do
      resolve &FormationsResolver.list_squads/3
    end

    @desc "Get a squad by number"
    field :squad, :squad do
      arg :squad_number, non_null(:string)

      resolve &FormationsResolver.find_squad/3
    end
  end

  mutation do
    @desc "Create a squad"
    field :create_squad, type: :squad do
      arg :squad_number, non_null(:string)
      arg :advertisment, :string
      arg :class_day, non_null(:integer)

      resolve &FormationsResolver.create_squad/3
    end

    @desc "Update a squad"
    field :update_squad, type: :squad do
      arg :id, non_null(:id)
      arg :squad_number, :string
      arg :advertisment, :string
      arg :class_day, :integer

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

    @desc "Delete/approve a squad_request"
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
