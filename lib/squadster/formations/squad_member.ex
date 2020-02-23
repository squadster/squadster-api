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

  # TODO: use cast_assoc/3 to cast assotiations
  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:role, :queue_number])
    # |> cast_assoc(:user, with: &Squadster.Accounts.User.changeset/2)
    # |> cast_assoc(:squad, with: &Squadster.Formations.Squad.changeset/2)
    |> validate_required([:role, :user, :squad])
  end
end
