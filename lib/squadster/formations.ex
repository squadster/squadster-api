defmodule Squadster.Formations do
  import Ecto.Query, only: [from: 2]

  alias Squadster.Repo
  alias Squadster.Helpers.Permissions
  alias Squadster.Formations.{Squad, SquadMember, SquadRequest}
  alias Squadster.Formations.Services.{
    CreateSquad,
    UpdateSquad,
    CreateSquadRequest,
    ApproveSquadRequest,
    UpdateSquadMember,
    DeleteSquadMember
  }

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params), do: queryable

  def list_squads do
    Repo.all(Squad)
  end

  def find_squad(number) do
    Squad |> Repo.get_by(squad_number: number)
  end

  def create_squad(args, user) do
    CreateSquad.call(args, user)
  end

  def update_squad(%{id: id} = args, user) do
    with squad <- Squad |> Repo.get(id) do
      if user |> Permissions.can_update?(squad) do
        UpdateSquad.call(args, squad)
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def delete_squad(id, user) do
    with squad <- Squad |> Repo.get(id) do
      if user |> Permissions.can_delete?(squad) do
        squad |> Repo.delete
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def create_squad_request(squad_id, user) do
    CreateSquadRequest.call(squad_id, user)
  end

  def approve_squad_request(id, approver) do
    with squad_request <- SquadRequest |> Repo.get(id) do
      if approver |> Permissions.can_update?(squad_request) do
        squad_request |> ApproveSquadRequest.call(approver)
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def delete_squad_request(id, user) do
    with squad_request <- SquadRequest |> Repo.get(id) do
      if user |> Permissions.can_delete?(squad_request) do
        squad_request |> Repo.delete
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def bulk_update_squad_members(args, user) do
    squad_members =
      Enum.map(args, fn data -> data[:id] end)
      |> all_members

    if user |> Permissions.can_update?(squad_members) do
      squad_members |> UpdateSquadMember.call(args)
    else
      {:error, "Not enough permissions"}
    end
  end

  def update_squad_member(%{id: id} = args, user) do
    with squad_member <- SquadMember |> Repo.get(id) do
      if user |> Permissions.can_update?(squad_member) do
        squad_member |> UpdateSquadMember.call(args)
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  def delete_squad_member(id, user) do
    with squad_member <- SquadMember |> Repo.get(id) do
      if user |> Permissions.can_delete?(squad_member) do
        squad_member |> DeleteSquadMember.call
      else
        {:error, "Not enough permissions"}
      end
    end
  end

  defp all_members(ids) do
    from(
      member in SquadMember,
      where: member.id in ^ids
    )
    |> Repo.all
  end
end
