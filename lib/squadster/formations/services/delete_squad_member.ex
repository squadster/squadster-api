defmodule Squadster.Formations.Services.DeleteSquadMember do
  alias Squadster.Repo
  alias Squadster.Formations.SquadMember

  def call(squad_member) do
    %{user: %{squad_request: squad_request}} = squad_member |> Repo.preload(user: :squad_request)
    unless is_nil(squad_request), do: squad_request |> Repo.delete

    squad_member |> SquadMember.delete
  end
end
