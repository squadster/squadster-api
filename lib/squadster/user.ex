defmodule Squadster.User do
  use Ecto.Schema

  import Ecto.Changeset
  require Logger
  require Poison

  alias Ueberauth.Auth
  alias Squadster.Repo
  alias Squadster.User
  alias Squadster.DateHelper

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :birth_date, :date
    field :email, :string
    field :mobile_phone, :string
    field :university, :string
    field :faculty, :string
    field :uid, :string
    field :auth_token, :string
    field :small_image_url, :string
    field :image_url, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uid, :first_name, :last_name, :email, :mobile_phone])
    |> validate_required([:uid, :first_name, :last_name])
    |> validate_format(:email, ~r/^.+@.+\..+$/)
    |> validate_format(:mobile_phone, ~r/^[-+()0-9]+$/)
  end

  def list_users do
    Repo.all(User)
  end

  def find_or_create(%Auth{extra: %{raw_info: %{user: info}}, credentials: %{token: token}} = auth) do
    uid = Integer.to_string(info["id"])
    user = Repo.get_by(User, uid: uid)
    if user do
      {:found, user}
    else
      {:created, Repo.insert(
        %User{
          first_name: info["first_name"],
          last_name: info["last_name"],
          birth_date: DateHelper.date_from_string(info["bdate"]),
          email: info["email"], # TODO: verify
          mobile_phone: info["mobile_phone"], # TODO: verify
          university: info["university_name"],
          faculty: info["faculty_name"],
          uid: uid,
          small_image_url: info["photo_100"],
          image_url: info["photo_200"],
          auth_token: token
        })
      }
    end
  end
end
