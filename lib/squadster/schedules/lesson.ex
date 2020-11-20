defmodule Squadster.Schedules.Lesson do
  use Ecto.Schema

  import Ecto.Changeset

  @available_types ["practical", "lecture", "lab"]

  schema "lessons" do
    field :name, :string
    field :teacher, :string
    field :index, :integer
    field :note, :string
    field :type, :string, default: "practical"
    field :classroom, :string
    belongs_to :timetable, Squadster.Schedules.Timetable

    timestamps()
  end

  def changeset(params) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :teacher, :index, :note, :type, :classroom, :timetable_id])
    |> validate_inclusion(:type, @available_types)
    |> validate_required([:name, :index, :timetable_id])
    |> foreign_key_constraint(:timetable_id)
  end
end
