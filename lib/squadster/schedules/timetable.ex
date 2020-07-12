defmodule Squadster.Schedule.Timetable do
  use Ecto.Schema

  import Ecto.Changeset

  alias Squadster.Repo

  schema "timetables" do
    field :date, :date
    has_many :lessons, Squadster.Schedule.Lesson, on_delete: :delete_all
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
