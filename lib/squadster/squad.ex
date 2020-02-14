defmodule Squadster.Squad do
  use Ecto.Schema

  import Ecto.Changeset

  schema "squad" do
    field :squad_number, :string
    field :advertisment, :string
    has_many :squad_members, Squadster.SquadMember

    timestamps()
  end

  def changeset(params) do
     changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:squad_number, :advertisment])
    |> validate_required([:squad_number])
  end
end
