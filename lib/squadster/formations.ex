defmodule Squadster.Formations do
  alias Squadster.Repo
  alias Squadster.Formations.Squad

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

  def create_squad(args) do
    args
    |> Squad.changeset
    |> Repo.insert
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
