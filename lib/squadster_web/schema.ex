defmodule Squadster.Schema do
  use Absinthe.Schema

  import_types SquadsterWeb.Schema.AccountTypes

  query do
    @desc "Get a list of users"
    field :users, list_of(:user) do
      resolve &SquadsterWeb.Resolvers.Accounts.list_users/3
    end

    @desc "Find user by id"
    field :user, :user do
      arg :id, non_null(:id)
      resolve &SquadsterWeb.Resolvers.Accounts.find_user/3
    end

    field :current_user, :user do
      resolve &SquadsterWeb.Resolvers.Accounts.current_user/3
    end
  end
end
