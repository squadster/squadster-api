defmodule Squadster.Formations.SquadMember do
  use Ecto.Schema

  import Ecto.Changeset
  import EctoEnum

  defenum RoleEnum, commander: 0, deputy_commander: 1, journalist: 2, student: 3

  schema "squad_members" do
    field :role, RoleEnum
    belongs_to :user, Squadster.Accounts.User
    belongs_to :squad, Squadster.Formations.Squad
    has_many :approved_squad_requests, Squadster.Formations.SquadRequest, foreign_key: :approver_id

    timestamps()
  end

  def changeset(params) do
     changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:role, :user, :squad])
    |> validate_required([:role, :user, :squad])
  end
end
