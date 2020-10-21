defmodule Squadster.Formations.Services.CreateSquadMember do
  import Mockery.Macro

  alias Squadster.Repo
  alias Squadster.Formations.SquadMember
  alias Squadster.Formations.Tasks.NormalizeQueue

  def call(user, squad) do
    %{squad_member: squad_member} = user |> Repo.preload(:squad_member)
    if squad_member do
      {:error, "User already has a squad_member"}
    else
      user
      |> create_squad_member(squad)
      |> schedule_queue_normalization
    end
  end

  def create_squad_member(user, squad) do
    SquadMember.changeset(%{user_id: user.id, squad_id: squad.id, role: :student})
    |> Repo.insert
  end

  defp schedule_queue_normalization({:error, _} = result), do: result
  defp schedule_queue_normalization({:ok, %{squad_id: squad_id}} = result) do
    mockable(NormalizeQueue).start_link([squad_id: squad_id])
    result
  end
end
