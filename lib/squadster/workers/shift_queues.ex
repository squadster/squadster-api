defmodule Squadster.Workers.ShiftQueues do
  use Task

  import Ecto.Query, only: [from: 2]

  alias Squadster.Formations.{Squad, SquadMember}
  alias Squadster.Repo
  alias Squadster.Helpers.Dates

  def start_link do
    Task.start_link(__MODULE__, :run, [])
  end

  def run do
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
      |> Enum.reject(fn %{queue_number: queue_number} -> is_nil(queue_number) end)

    %{queue_number: last_number} = Enum.max_by(members, &(&1.queue_number), fn -> %{queue_number: 1} end)

    members |> Enum.each(fn member -> member |> update(last_number) end)
  end

  defp update(%SquadMember{queue_number: 1} = member, last_number) do
    member
    |> SquadMember.changeset(%{queue_number: last_number})
    |> Repo.update
  end

  defp update(member, _last_number) do
    member
    |> SquadMember.changeset(%{queue_number: member.queue_number - 1})
    |> Repo.update
  end
end
