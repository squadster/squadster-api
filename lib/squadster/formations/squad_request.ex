defmodule Squadster.Formations.SquadRequest do
  use Ecto.Schema

  import Ecto.Changeset

  schema "squad_requests" do
    belongs_to :approver, Squadster.Formations.SquadMember
    belongs_to :user, Squadster.Accounts.User
    belongs_to :squad, Squadster.Formations.Squad
    field :approved_at, :utc_datetime

    timestamps()
  end

  def changeset(params) do
     changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:approved_at, :user_id, :squad_id, :approver_id])
    |> validate_required([:user_id, :squad_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:squad_id)
    |> foreign_key_constraint(:approver_id)
  end
end
