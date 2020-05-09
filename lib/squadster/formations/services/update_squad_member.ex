defmodule Squadster.Formations.Services.UpdateSquadMember do
  import Ecto.Query, only: [from: 2]

  alias Ecto.Multi
  alias Squadster.Repo
  alias Squadster.Formations.SquadMember

  def call(squad_member, %{id: id} = args) do
    if args[:role] == "commander", do: demote_extra_commanders(squad_member)

    SquadMember
    |> Repo.get(id)
    |> SquadMember.changeset(args)
    |> SquadMember.update
  end

  def call(squad_members, args) when is_list(squad_members) do
    squad_members
    |> Enum.reduce(Multi.new(), fn member, batch ->
      data = member_changes(args, member.id)
      batch |> Multi.update(
        member.id,
        member |> SquadMember.changeset(data)
      )
    end)
    |> Repo.transaction
  end

  defp demote_extra_commanders(squad_member) do
    from(
      member in SquadMember,
      where: member.squad_id == ^squad_member.squad_id and member.role == ^commander_role(),
      update: [set: [role: ^student_role()]]
    ) |> Repo.update_all([])
  end

  defp commander_role do
    SquadMember.RoleEnum.__enum_map__[:commander]
  end

  defp student_role do
    SquadMember.RoleEnum.__enum_map__[:student]
  end

  defp member_changes(args, id) do
    Enum.find(args, fn arg -> String.to_integer(arg[:id]) == id end)
  end
end
