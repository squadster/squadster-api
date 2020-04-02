defmodule Squadster.Formations.SquadMember do
  use Ecto.Schema

  import Ecto.Changeset
  import EctoEnum

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
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:squad_id)
  end

  def parse_role(role) do
    {:ok, role} = RoleEnum.cast(role)
    role
  end

  def serialize_role(role) do
    Atom.to_string(role)
  end
end
