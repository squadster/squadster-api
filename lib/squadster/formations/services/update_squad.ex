defmodule Squadster.Formations.Services.UpdateSquad do
  alias Squadster.Repo
  alias Squadster.Formations.Squad
  alias Squadster.Formations.Services.NotifySquadChanges

  def call(squad, args, user) do
    changeset = squad |> Squad.changeset(args)

    case changeset |> Repo.update do
      {:ok, squad} ->
        changeset.changes |> NotifySquadChanges.call(squad, user)
        {:ok, squad}
      {:error, reason} -> {:error, reason}
    end
  end
end