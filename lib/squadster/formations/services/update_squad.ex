defmodule Squadster.Formations.Services.UpdateSquad do
  import Mockery.Macro

  alias Squadster.Repo
  alias Squadster.Formations.Squad
  alias Squadster.Formations.Services.NotifySquadChanges

  def call(squad, args, user) do
    changeset = squad |> Squad.changeset(args)

    case changeset |> Repo.update do
      {:ok, squad} ->
        changeset.changes |> mockable(NotifySquadChanges).call(squad, user)
        {:ok, squad |> Squad.load}
      {:error, reason} -> {:error, reason}
    end
  end
end
