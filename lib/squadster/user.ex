defmodule Squadster.User do
  use Ecto.Schema

  import Ecto.Changeset
  require Logger
  require Poison

  alias Ueberauth.Auth
  alias Squadster.Repo
  alias Squadster.User

  schema "users" do
    field :uid, :string
    field :vk_url, :string
    field :image_url, :string
    field :first_name, :string
    field :last_name, :string
    field :birth_date, :date
    field :email, :string
    field :mobile_phone, :string
    field :university, :string
    field :faculty, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uid, :first_name, :last_name, :email, :university, :faculty])
    |> validate_required([:uid, :first_name, :last_name])
    |> validate_format(:email, ~r/^.+@.+\..+$/)
    |> validate_format(:mobile_phone, ~r/^[-+()0-9]+$/)
  end

  def list_users do
    Repo.all(User)
  end

  def find_or_create_from_auth(%Auth{} = auth) do
    require IEx
    IEx.pry
    auth.extra.raw_info.user["id"]



    user = Repo.get_by(User, uid: auth.uid)
    if user, do: user, else: Repo.insert(User, auth)
  end

  def create_from_auth(%Auth{} = auth) do

  end

  # defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image
end
