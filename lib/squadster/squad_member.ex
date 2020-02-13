defmodule Squadster.SquadMember do
  use Ecto.Schema

  import Ecto.Changeset
  import EctoEnum

  defenum RoleEnum, commander: 0, deputy_commander: 1, journalist: 2, student: 3

  schema "squad_members" do
    field :role, RoleEnum
    belongs_to :user, Squadster.Accounts.User
    belongs_to :squad, Squadster.Squad

    timestamps()
  end

  def changeset(params) do
     changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:role])
    |> validate_required([:role])
  end
end
