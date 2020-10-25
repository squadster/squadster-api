defmodule Squadster.Support.RepoHelper do
  import Ecto.Query, only: [from: 2]

  alias Squadster.Repo

  def entities_count(struct) do
    struct |> Repo.all |> Enum.count
  end

  def last(struct) do
    Repo.one(from s in struct, order_by: [desc: s.id], limit: 1)
  end

  def reload(struct) do
    struct.__struct__ |> Repo.get(struct.id)
  end
end
