defmodule SquadsterWeb.Resolvers.Formations do
  alias Squadster.Formations

  def list_squads(_parent, _args, _resolution) do
    {:ok, Formations.list_squads}
  end

  def find_squad(_parent, %{squad_number: number}, _resolution) do
    case Formations.find_squad(number) do
      nil -> {:error, "squad with number #{number} does not exist"}
      squad -> {:ok, squad}
    end
  end

  def create_squad(_parent, args, %{context: %{current_user: user}}) do
    Formations.create_squad(args, user)
  end

  def create_squad(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
