defmodule Squadster.Workers.ShiftQueueNumbers do
  use Task

  import Ecto.Query, only: [from: 2]

  alias Squadster.Formations.{Squad, SquadMember}
  alias Squadster.Repo
  alias Squadster.Helpers.Dates

  def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
  end

  def run(_args) do
    class_day = yesterday()
    from(squad in Squad, where: squad.class_day == ^class_day)
    |> Repo.all()
    |> Repo.preload(:members)
    |> Enum.each(fn squad ->
      update_query(squad.members)
    end)
  end

  defp yesterday do
    Dates.yesterday |> Dates.day_of_a_week
  end

  defp update_query(members) do
    members =
      members
      |> Enum.filter(fn member -> !is_nil(member.queue_number) end)

    last_number = Enum.max_by(members, &(&1.queue_number)).queue_number

    members
    |> Enum.each(fn member -> update_member(member, last_number) end)
  end

  defp update_member(%SquadMember{queue_number: 1} = member, last_number) do
    member
    |> SquadMember.changeset(%{queue_number: last_number})
    |> Repo.update
  end

  defp update_member(member, _last_number) do
    member
    |> SquadMember.changeset(%{queue_number: member.queue_number - 1})
    |> Repo.update
  end
end
