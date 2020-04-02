defmodule Squadster.Helpers.Permissions do
  alias Squadster.Repo
  alias Squadster.Accounts.User
  alias Squadster.Formations.{Squad, SquadRequest, SquadMember}

  def can_update?(%User{} = user, %Squad{} = squad) do
    %{squad_member: member} = user |> Repo.preload(squad_member: :squad)

    cond do
      is_nil(member) -> false
      member.role in [:commander, :deputy_commander, :journalist] and squad == member.squad -> true
      true -> false
    end
  end

  def can_update?(%User{} = user, %SquadRequest{} = squad_request) do
    %{squad_member: approver} = user |> Repo.preload(squad_member: :squad)
    %{squad: squad} = squad_request |> Repo.preload(:squad)

    cond do
      is_nil(approver) -> false
      approver.role in [:commander, :deputy_commander, :journalist] and squad == approver.squad -> true
      true -> false
    end
  end

  def can_update?(%User{} = user, %SquadMember{} = squad_member) do
    %{squad: squad, user: member_user} = squad_member |> Repo.preload(:squad) |> Repo.preload(:user)
    member_user != user && can_delete?(user, squad)
  end

  def can_delete?(%User{} = user, %Squad{} = squad) do
    %{squad_member: member} = user |> Repo.preload(squad_member: :squad)

    cond do
      is_nil(member) -> false
      member.role in [:commander] and squad == member.squad -> true
      true -> false
    end
  end

  def can_delete?(%User{} = user, %SquadRequest{} = squad_request) do
    %{squad_member: member} = user |> Repo.preload(squad_member: :squad)
    %{squad: squad, user: request_user} = squad_request |> Repo.preload(:squad) |> Repo.preload(:user)

    cond do
      request_user == user -> true
      is_nil(member) -> false
      member.role in [:commander, :deputy_commander, :journalist] and squad == member.squad -> true
      true -> false
    end
  end

  def can_delete?(%User{} = user, %SquadMember{} = squad_member) do
    can_update?(user, squad_member)
  end
end
