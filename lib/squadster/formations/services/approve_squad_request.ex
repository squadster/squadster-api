defmodule Squadster.Formations.Services.ApproveSquadRequest do
  import Mockery.Macro

  alias Squadster.Repo
  alias Squadster.Formations.{SquadRequest, SquadMember}
  alias Squadster.Formations.Tasks.NormalizeQueue

  def call(squad_request, approver_user) do
    %{squad_member: approver} = approver_user |> Repo.preload(:squad_member)
    squad_request |> approve(approver)
    squad_request |> create_squad_member
  end

  defp approve(squad_request, %{id: approver_id}) do
    squad_request
    |> SquadRequest.approve_changeset(%{approver_id: approver_id})
    |> Repo.update
  end

  defp create_squad_member(%{user_id: user_id, squad_id: squad_id}) do
    SquadMember.changeset(%{user_id: user_id, squad_id: squad_id, role: :student})
    |> Repo.insert
    |> schedule_queue_normalization
  end

  defp schedule_queue_normalization({:ok, %{squad_id: squad_id}} = result) do
    mockable(NormalizeQueue).start_link([squad_id: squad_id])
    result
  end

  defp schedule_queue_normalization({:error, _} = result), do: result
end
