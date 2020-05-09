defmodule Squadster.Formations.Services.UpdateSquadMember do
  import Ecto.Query, only: [from: 2]

  alias Squadster.Repo
  alias Squadster.Formations.SquadMember

  def call(squad_member, %{id: id} = args, user) do
    if args[:role] == "commander", do: demote_extra_commanders(squad_member)

    SquadMember
    |> Repo.get(id)
    |> SquadMember.changeset(args)
    |> SquadMember.update
  end

  def call(squad_member, args, user) do

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
end
