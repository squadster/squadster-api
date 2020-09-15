defmodule Squadster.Formations.Services.DeleteSquadMember do
  import Mockery.Macro

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
    mockable(NormalizeQueue).start_link([squad_id: squad_id])
    result
  end

  defp schedule_queue_normalization({:error, _} = result), do: result
end
