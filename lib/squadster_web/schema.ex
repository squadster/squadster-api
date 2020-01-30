defmodule Squadster.Schema do
  use Absinthe.Schema

  import_types SquadsterWeb.Schema.DataTypes

  query do
    @desc "Get a list of users"
    field :user, list_of(:user) do
      resolve fn _parent, _args, _resolution ->
        {:ok, Squadster.User.list_users()}
      end
    end
  end
end
