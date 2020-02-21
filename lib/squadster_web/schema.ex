defmodule Squadster.Schema do
  use Absinthe.Schema

  alias SquadsterWeb.Resolvers.Accounts, as: AccountsResolver
  alias Squadster.{Accounts, Formations}

  import_types SquadsterWeb.Schema.AccountTypes

  query do
    @desc "Get a list of users"
    field :users, list_of(:user) do
      resolve &AccountsResolver.list_users/3
    end

    @desc "Find user by id"
    field :user, :user do
      arg :id, non_null(:id)
      resolve &AccountsResolver.find_user/3
    end

    @desc "Get current user"
    field :current_user, :user do
      resolve &AccountsResolver.current_user/3
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
