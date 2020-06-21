defmodule Squadster.Formations.Services.DeleteSquadMember do
  alias Squadster.Repo
  alias Squadster.Formations.Tasks.NormalizeQueue

  def call(squad_member) do
    %{user: %{squad_request: squad_request}} = squad_member |> Repo.preload(user: :squad_request)
    unless is_nil(squad_request), do: squad_request |> Repo.delete

    squad_member
    |> Repo.delete
    |> schedule_queue_normalization
  end

  defp schedule_queue_normalization({:ok, %{squad_id: squad_id}} = result) do
    # TODO: should be start_link, but need to fix tests
    NormalizeQueue.run([squad_id: squad_id])
    result
  end

  defp schedule_queue_normalization({:error, _} = result), do: result
end
