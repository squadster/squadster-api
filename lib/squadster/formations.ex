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
end
