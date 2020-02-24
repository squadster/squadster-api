defmodule Squadster.Formations.SquadRequest do
  use Ecto.Schema

  import Ecto.Changeset

  alias Squadster.Helpers.Dates

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
    |> cast(params, [:user_id, :squad_id])
    |> validate_required([:user_id, :squad_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:squad_id)
  end

  def approve_changeset(params) do
    approve_changeset(%__MODULE__{}, params)
  end

  def approve_changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:approved_at, :approver_id, :user_id, :squad_id])
    |> put_change(:approved_at, Dates.without_microseconds(Timex.now))
    |> validate_required([:user_id, :squad_id, :approver_id, :approved_at])
    |> foreign_key_constraint(:approver_id)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:squad_id)
  end
end
