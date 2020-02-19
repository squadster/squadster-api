defmodule Squadster.Formations.Squad do
  use Ecto.Schema

  import Ecto.Changeset
  import EctoEnum

  defenum ClassDayEnum, monday: 1, twesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7

  schema "squads" do
    field :squad_number, :string
    field :advertisment, :string
    field :class_day, ClassDayEnum
    has_many :squad_members, Squadster.Formations.SquadMember

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
