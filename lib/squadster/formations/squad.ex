defmodule Squadster.Formations.Squad do
  use Ecto.Schema

  import Ecto.Changeset
  import EctoEnum

  alias Squadster.Repo

  defenum ClassDayEnum, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7

  schema "squads" do
    field :hash_id, :string
    field :squad_number, :string
    field :advertisment, :string
    field :link_invitations_enabled, :boolean
    field :class_day, ClassDayEnum
    has_many :members, Squadster.Formations.SquadMember, on_delete: :delete_all
    has_many :requests, Squadster.Formations.SquadRequest, on_delete: :delete_all
    has_many :timetables, Squadster.Schedules.Timetable, on_delete: :delete_all

    timestamps()
  end

  def changeset(params) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:squad_number, :advertisment, :class_day, :link_invitations_enabled])
    |> validate_required([:squad_number, :class_day])
    |> set_hash_id
  end

  def set_hash_id(%Ecto.Changeset{data: squad} = changeset) do
    unless squad.hash_id do
      changeset |> Ecto.Changeset.put_change(:hash_id, :crypto.strong_rand_bytes(16) |> Base.url_encode64)
    else
      changeset
    end
  end

  def commander(squad) do
    squad
    |> Ecto.assoc(:members)
    |> Repo.get_by(role: :commander)
  end
end
