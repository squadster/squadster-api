defmodule Squadster.Formations do
  alias Squadster.Repo
  alias Squadster.Formations.Squad
  alias Squadster.Formations.SquadMember

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def list_squads() do
    Repo.all(Squad)
  end

  def find_squad(number) do
    Squad |> Repo.get_by(squad_number: number)
  end

  def create_squad(args, user) do
    user
    |> Repo.preload(:squad_member)
    |> case do
      %{squad_member: nil} ->
        args
        |> Squad.changeset
        |> Repo.insert
        |> add_commander_to_squad(user)
      %{squad_member: _member} -> {:error, "Delete existing squad to create new one"}
    end
  end

  defp add_commander_to_squad(squad_response, user) do
    {:ok, squad} = squad_response
    %{role: :commander, user_id: user.id, squad_id: squad.id}
    |> SquadMember.changeset
    |> Repo.insert
  end

  def update_squad(args) do
    Squad
    |> Repo.get(args.id)
    |> Squad.changeset(args)
    |> Repo.update
  end

  def delete_squad(id) do
    Squad
    |> Repo.get(id)
    |> Repo.delete
  end
end
