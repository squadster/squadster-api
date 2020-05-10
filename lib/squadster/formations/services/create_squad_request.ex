defmodule Squadster.Formations.Services.CreateSquadRequest do
  alias Squadster.Repo
  alias Squadster.Formations.SquadRequest

  def call(squad_id, user) do
    %{squad_request: existing_request, squad_member: squad_member} =
      user
      |> Repo.preload(:squad_request)
      |> Repo.preload(:squad_member)

    if is_nil(squad_member) do
      create(user.id, squad_id, existing_request)
    else
      {:error, "User already has squad"}
    end
  end

  defp create(user_id, squad_id, existing_request) do
    unless is_nil(existing_request), do: existing_request |> Repo.delete

    %{user_id: user_id, squad_id: squad_id}
    |> SquadRequest.changeset
    |> Repo.insert
  end
end
