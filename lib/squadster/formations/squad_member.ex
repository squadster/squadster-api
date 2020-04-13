defmodule Squadster.Formations.SquadMember do
  use Ecto.Schema

  import Ecto.Changeset
  import EctoEnum

  alias Squadster.Formations.Squad
  alias Squadster.Repo

  defenum RoleEnum, commander: 0, deputy_commander: 1, journalist: 2, student: 3

  schema "squad_members" do
    field :role, RoleEnum
    field :queue_number, :integer
    belongs_to :user, Squadster.Accounts.User
    belongs_to :squad, Squadster.Formations.Squad

    timestamps()
  end

  def changeset(params) do
     changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:role, :queue_number, :user_id, :squad_id])
    |> validate_required([:role, :user_id, :squad_id])
    |> reset_queue_number
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:squad_id)
  end

  defp reset_queue_number(%Ecto.Changeset{data: member, changes: %{role: new_role}} = changeset) do
    cond do
      new_role |> should_be_on_duty? && member |> in_queue? -> changeset
      new_role |> should_be_on_duty? -> changeset |> to_end
      true -> changeset |> remove_from_queue
    end
  end

  defp reset_queue_number(changeset), do: changeset

  defp should_be_on_duty?(role) do
    cond do
      role in [:commander, :deputy_commander, :journalist] -> false
      true -> true
    end
  end

  defp in_queue?(%{queue_number: nil}), do: false
  defp in_queue?(%{queue_number: _}),   do: true

  defp to_end(%{changes: %{squad_id: squad_id}} = changeset) do
    %{members: members} = Squad |> Repo.get(squad_id) |> Repo.preload(:members)
    changeset |> put_change(:queue_number, (members |> last_number) + 1)
  end

  defp to_end(%{data: member} = changeset) do
    %{squad: %{members: members}} = member |> Repo.preload(squad: :members)
    changeset |> put_change(:queue_number, (members |> last_number) + 1)
  end

  defp last_number(members) do
    %{queue_number: last_number} =
      members
      |> Enum.filter(fn %{queue_number: queue_number} -> !is_nil(queue_number) end)
      |> Enum.max_by(&(&1.queue_number), fn -> %{queue_number: 0} end)

    last_number
  end

  defp remove_from_queue(changeset) do
    changeset |> put_change(:queue_number, nil)
  end

  def parse_role(role) do
    {:ok, role} = RoleEnum.cast(role)
    role
  end

  def serialize_role(role) do
    Atom.to_string(role)
  end
end
