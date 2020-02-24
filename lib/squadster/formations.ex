defmodule Squadster.Formations do
  alias Squadster.Repo
  alias Squadster.Helpers.Permissions
  alias Squadster.Formations.{Squad, SquadMember, SquadRequest}

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def list_squads() do
    Repo.all(Squad)
  end

  def find_squad(number) do
    Squad |> Repo.get_by(squad_number: number)
  end

  def create_squad(args, user) do
    user
    |> Repo.preload(:squad_member)
    |> case do
      %{squad_member: nil} ->
        args
        |> Squad.changeset
        |> Repo.insert
        |> add_commander_to_squad(user)
      %{squad_member: _member} -> {:error, "Delete existing squad to create new one"}
    end
  end

  def update_squad(%{id: id} = args, user) do
    with squad <- Squad |> Repo.get(id) do
      if Permissions.can_update?(user, squad) do
        squad
        |> Squad.changeset(args)
        |> Repo.update
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def delete_squad(id, user) do
    with squad <- Squad |> Repo.get(id) do
      if Permissions.can_delete?(user, squad) do
        squad |> Repo.delete
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def create_squad_request(squad_id, user) do
    %{squad_request: squad_request} = user |> Repo.preload(:squad_request)
    unless is_nil(squad_request), do: squad_request |> Repo.delete

    %{user_id: user.id, squad_id: squad_id}
    |> SquadRequest.changeset
    |> Repo.insert
  end

  # TODO: new changeset?
  def approve_squad_request(id, approver) do
    with squad_request <- SquadRequest |> Repo.get(id) do
      if Permissions.can_update?(approver, squad_request) do
        squad_request
        |> SquadRequest.approve_changeset(%{approver_id: approver.id})
        |> Repo.update
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def delete_squad_request(id, user) do
    with squad_request <- SquadRequest |> Repo.get(id) do
      if Permissions.can_delete?(user, squad_request) do
        squad_request |> Repo.delete
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  defp add_commander_to_squad(squad_response, user) do
    {:ok, squad} = squad_response

    %{role: :commander, user_id: user.id, squad_id: squad.id}
    |> SquadMember.changeset
    |> Repo.insert
  end
end
