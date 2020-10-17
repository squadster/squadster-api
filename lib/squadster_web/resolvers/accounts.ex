defmodule SquadsterWeb.Resolvers.Accounts do
  alias Squadster.Accounts

  import Mockery.Macro

  def user(_parent, %{id: id}, _resolution) do
    case Accounts.find_user(id) do
      nil  -> {:error, "user with id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def users(_parent, _args, _resolution) do
    {:ok, Accounts.list_users}
  end

  def current_user(_parent, _args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def current_user(_parent, _args, _resolution) do
    {:error, "Not logged in"}
  end

  def update_user(_parent, args, %{context: %{current_user: current_user}}) do
    mockable(Accounts).update_user(args, current_user)
  end

  def update_user(_parent, _args, _resolution) do
    {:error, "Not logged in"}
  end
end
