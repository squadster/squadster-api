defmodule Squadster.Formations.Services.ApproveSquadRequest do
  alias Squadster.Repo
  alias Squadster.Formations.{SquadRequest, SquadMember}
  alias Squadster.Workers.NormalizeQueue

  def call(squad_request, approver) do
    %{squad_member: %{id: approver_id}} = approver |> Repo.preload(:squad_member)
    squad_request |> approve(approver_id)
    squad_request |> create_squad_member
  end

  defp approve(squad_request, approver_id) do
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
    # TODO: should be start_link, but need to fix tests
    NormalizeQueue.run([squad_id: squad_id])
    result
  end

  defp schedule_queue_normalization({:error, _} = result), do: result
end
