defmodule SquadsterWeb.Resolvers.Accounts do
  alias Squadster.Accounts

  import Mockery.Macro

  def current_user(_parent, _args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def current_user(_parent, _args, _resolution) do
    {:error, "Not logged in"}
  end

  def update_current_user(_parent, args, %{context: %{current_user: current_user}}) do
    mockable(Accounts).update_user(args, current_user)
  end

  def update_current_user(_parent, _args, _resolution) do
    {:error, "Not logged in"}
  end

  def update_user_settings(_parent, args, %{context: %{current_user: current_user}}) do
    mockable(Accounts).update_user_settings(args, current_user)
  end

  def update_user_settings(_parent, _args, _resolution) do
    {:error, "Not logged in"}
  end
end
