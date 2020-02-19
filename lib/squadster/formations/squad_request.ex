defmodule Squadster.Formations.SquadRequest do
  use Ecto.Schema

  import Ecto.Changeset

  schema "squad_requests" do
    has_one :approver, Squadster.Formations.SquadMember
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
    |> cast(params, [:user, :squad])
    |> validate_required([:user, :squad])
  end
end
