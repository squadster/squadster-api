defmodule Squadster.Helpers.Permissions do
  alias Squadster.Repo
  alias Squadster.Accounts.User
  alias Squadster.Formations.{Squad, SquadRequest}

  @doc "Check if user can update squad"
  def can_update?(%User{} = user, %Squad{} = squad) do
    %{squad_member: member} = user |> Repo.preload(:squad_member)
    member = member |> Repo.preload(:squad)

    cond do
      is_nil(member) -> false
      member.role in [:commander, :deputy_commander, :journalist] and squad == member.squad -> true
      true -> false
    end
  end

  @doc "Check if user can update squad_request"
  def can_update?(%User{} = user, %SquadRequest{} = squad_request) do
    %{squad_member: approver} = user |> Repo.preload(:squad_member)
    approver = approver |> Repo.preload(:squad)
    %{squad: squad} = squad_request |> Repo.preload(:squad)

    cond do
      is_nil(approver) -> false
      approver.role in [:commander, :deputy_commander] and squad == approver.squad -> true
      true -> false
    end
  end

  @doc "Check if user can delete squad"
  def can_delete?(%User{} = user, %Squad{} = squad) do
    %{squad_member: member} = user |> Repo.preload(:squad_member)
    member = member |> Repo.preload(:squad)

    cond do
      is_nil(member) -> false
      member.role in [:commander] and squad == member.squad -> true
      true -> false
    end
  end

  @doc "Check if user can delete squad_request"
  def can_delete?(%User{} = user, %SquadRequest{} = squad_request) do
    %{squad_member: member} = user |> Repo.preload(:squad_member)
    member = member |> Repo.preload(:squad)
    %{squad: squad, user: request_user} = squad_request |> Repo.preload(:squad) |> Repo.preload(:user)

    cond do
      is_nil(member) -> false
      request_user == user -> true
      member.role in [:commander, :deputy_commander] and squad == member.squad -> true
      true -> false
    end
  end
end
