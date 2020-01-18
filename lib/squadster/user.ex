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
    |> cast(params, [:first_name, :last_name, :birth_date, :email, :mobile_phone, :university, :faculty])
    |> validate_required([:first_name, :last_name])
    |> validate_format(:email, ~r/^.+@.+\..+$/)
    |> validate_format(:mobile_phone, ~r/^[-+()0-9]+$/)
  end

  def auth_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, auth_fields)
    |> validate_required([:uid, :first_name, :last_name])
  end

  def list_users do
    Repo.all(User)
  end

  def find_or_create(%Auth{extra: %{raw_info: %{user: info}}, credentials: %{token: token}} = auth) do
    user = Repo.get_by(User, uid: uid_from_auth(auth))
    if user do
      user
      |> auth_changeset(data_from_auth(auth))
      |> delete_change(:uid)
      |> Repo.update()
    else
      Repo.insert(auth_changeset(%User{}, data_from_auth(auth)))
    end
  end

  defp data_from_auth(%Auth{extra: %{raw_info: %{user: info}}, credentials: %{token: token}} = auth) do
    %{
      first_name: info["first_name"],
      last_name: info["last_name"],
      birth_date: DateHelper.date_from_string(info["bdate"]),
      email: info["email"], # TODO: verify
      mobile_phone: info["mobile_phone"], # TODO: verify
      university: info["university_name"],
      faculty: info["faculty_name"],
      small_image_url: info["photo_100"],
      image_url: info["photo_200"],
      uid: uid_from_auth(auth),
      auth_token: token
    }
  end

  defp uid_from_auth(%Auth{extra: %{raw_info: %{user: %{"id" => uid}}}}) do
    Integer.to_string(uid)
  end

  defp auth_fields do
    [
      :first_name,
      :last_name,
      :birth_date,
      :email,
      :mobile_phone,
      :university,
      :faculty,
      :uid,
      :auth_token,
      :small_image_url,
      :image_url
    ]
  end
end
