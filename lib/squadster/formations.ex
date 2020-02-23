defmodule Squadster.Formations do
  alias Squadster.Repo
  alias Squadster.Accounts.User
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
    user = user |> Repo.preload(:squad_member)
    case user.squad_member do
      nil ->
        args
        |> Squad.changeset
        |> Repo.insert
        |> create_squad_member(user)
      _member -> {:error, "Delete existing squad to create new one"}
    end
  end

  # TODO: Refactor member creation with changeset
  defp create_squad_member(squad, user) do
    case squad do
      {:ok, squadster} ->
        # new_member = %SquadMember{role: 0, user: user, squad: squadster}
        # |> SquadMember.changeset
        # |> Repo.insert
        Repo.insert!(%SquadMember{
          role: :commander,
          user: user,
          squad: squadster
        })
        {:ok, squadster}
      {:error, reason} -> {:error, reason}
    end
  end

  def update_squad(args) do
    squad = Squad |> Repo.get(args.id)
    |> Squad.changeset(args)
    |> Repo.update
  end

  def delete_squad(id) do
    squad = Squad |> Repo.get(id)
    |> Repo.delete
  end
end
