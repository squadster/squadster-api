defmodule SquadsterWeb.Resolvers.Accounts do
  alias Squadster.Accounts

  def find_user(_parent, %{id: id}, _resolution) do
    case Accounts.find_user(id) do
      nil ->
        {:error, "user with id #{id} not found"}
      user ->
        {:ok, user}
    end
  end

  def list_users(_parent, _args, _resolution) do
    Accounts.list_users
  end
end
