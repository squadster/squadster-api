defmodule Squadster.Helpers.Permissions do
  alias Squadster.Repo
  alias Squadster.Accounts.User
  alias Squadster.Formations.{Squad, SquadRequest, SquadMember}

  @management_roles [:commander, :deputy_commander, :journalist]

  def can_update?(%User{} = user, %Squad{} = squad) do
    user |> has_management_role_in?(squad)
  end

  def can_update?(%User{} = user, %SquadRequest{} = squad_request) do
    %{squad: squad} = squad_request |> Repo.preload(:squad)
    user |> has_management_role_in?(squad)
  end

  def can_update?(%User{} = user, %SquadMember{} = squad_member) do
    %{squad: squad, user: member_user} = squad_member |> Repo.preload(:squad) |> Repo.preload(:user)
    member_user.id != user.id && (user |> has_commander_role_in?(squad))
  end

  def can_update?(%User{} = user, squad_members) when is_list(squad_members) do
    %{squad_member: %{squad: squad}} = user |> Repo.preload(squad_member: [:squad, squad: :members])
    user |> has_commander_role_in?(squad) && from_squad?(squad_members, squad.members)
  end

  def can_delete?(%User{} = user, %Squad{} = squad) do
    user |> has_commander_role_in?(squad)
  end

  def can_delete?(%User{} = user, %SquadRequest{} = squad_request) do
    %{squad: squad, user: request_user} = squad_request |> Repo.preload(:squad) |> Repo.preload(:user)
    request_user.id == user.id || (user |> has_management_role_in?(squad))
  end

  def can_delete?(%User{} = user, %SquadMember{} = squad_member) do
    %{squad: squad, user: member_user} = squad_member |> Repo.preload(:squad) |> Repo.preload(:user)
    member_user.id == user.id || (user |> has_commander_role_in?(squad))
  end

  defp from_squad?(squad_members, all_members) do
    MapSet.subset?(MapSet.new(squad_members), MapSet.new(all_members))
  end

  defp has_commander_role_in?(%User{} = user, %Squad{} = squad) do
    user |> has_role_in?(squad, [:commander])
  end

  defp has_management_role_in?(%User{} = user, %Squad{} = squad) do
    user |> has_role_in?(squad, @management_roles)
  end

  defp has_role_in?(%User{} = user, %Squad{} = squad, roles) when is_list(roles) do
    %{squad_member: member} = user |> Repo.preload(squad_member: :squad)

    cond do
      is_nil(member) -> false
      member.role in roles and squad.id == member.squad.id -> true
      true -> false
    end
  end
end
