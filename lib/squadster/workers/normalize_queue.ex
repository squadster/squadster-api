defmodule Squadster.Workers.NormalizeQueue do
  use Task

  alias Ecto.Multi
  alias Squadster.Repo
  alias Squadster.Formations.{Squad, SquadMember}

  def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
  end

  def run([squad_id: squad_id]) do
    %{members: members} = Squad |> Repo.get(squad_id) |> Repo.preload(:members)
    not_on_duty = members |> Enum.reject(fn member -> member.role == :student end)
    on_duty = members -- not_on_duty

    not_on_duty |> remove_from_queue
    on_duty |> normalize_queue
  end

  def remove_from_queue(members) do
    members
    |> Enum.reduce(Multi.new(), fn member, batch ->
      batch
      |> Multi.update(member.id, SquadMember.changeset(member, %{queue_number: nil}))
    end)
    |> Repo.transaction
  end

  def normalize_queue(members) do
    members
    |> Enum.sort_by(fn member -> member.queue_number end)
    |> Enum.with_index
    |> Enum.reduce(Multi.new(), fn {member, index}, batch ->
      batch
      |> Multi.update(member.id, SquadMember.changeset(member, %{queue_number: index + 1}))
    end)
    |> Repo.transaction
  end
end
