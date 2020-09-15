defmodule Squadster.Schedules.Timetable do
  use Ecto.Schema

  import Ecto.Changeset

  schema "timetables" do
    field :date, :date
    has_many :lessons, Squadster.Schedules.Lesson, on_delete: :delete_all
    belongs_to :squad, Squadster.Formations.Squad

    timestamps()
  end

  def changeset(params) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:date, :squad_id])
    |> validate_required([:squad_id])
    |> foreign_key_constraint(:squad_id)
  end
end
