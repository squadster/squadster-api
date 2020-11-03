defmodule Squadster.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  require Logger
  require Poison

  alias Ueberauth.Auth
  alias Squadster.Helpers.Dates

  @vk_url "https://vk.com/"
  @auth_fields [
    :first_name,
    :last_name,
    :birth_date,
    :mobile_phone,
    :university,
    :faculty,
    :uid,
    :auth_token,
    :small_image_url,
    :image_url,
    :vk_url
  ]

  @user_fields [
    :first_name,
    :last_name,
    :birth_date,
    :mobile_phone,
    :university,
    :faculty
  ]

  @vk_priority_fields [
    :vk_url,
    :small_image_url,
    :image_url,
    :auth_token
  ]

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :birth_date, :date
    field :mobile_phone, :string
    field :university, :string
    field :faculty, :string
    field :uid, :string
    field :auth_token, :string
    field :small_image_url, :string
    field :image_url, :string
    field :vk_url, :string
    has_one :squad_member, Squadster.Formations.SquadMember
    has_one :squad_request, Squadster.Formations.SquadRequest
    timestamps()
  end

  def user_fields, do: [:id | @auth_fields]

  def changeset(params) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @user_fields)
    |> validate_required([:first_name, :last_name])
    |> validate_format(:mobile_phone, ~r/^[-+()0-9]+$/)
  end

  def auth_changeset(params) do
    auth_changeset(%__MODULE__{}, params)
  end

  def auth_changeset(%__MODULE__{} = struct, params \\ %{}) do
    filtered_params = params |> reject_existing_fields(struct)

    struct
    |> cast(filtered_params, @auth_fields)
    |> validate_required([:uid])
  end

  def data_from_auth(%Auth{extra: %{raw_info: %{user: info}}, credentials: %{token: token}, info: %{phone: phone}} = auth) do
    %{
      first_name: info["first_name"],
      last_name: info["last_name"],
      birth_date: Dates.date_from_string(info["bdate"]),
      mobile_phone: phone,
      university: info["university_name"],
      faculty: info["faculty_name"],
      small_image_url: info["photo_100"],
      image_url: info["photo_400"],
      uid: uid_from_auth(auth),
      vk_url: @vk_url <> (info["domain"] || ""),
      auth_token: token
    }
  end

  def uid_from_auth(%Auth{extra: %{raw_info: %{user: %{"id" => uid}}}}) do
    Integer.to_string(uid)
  end

  defp reject_existing_fields(params, user) do
    params |> Enum.filter(fn {key, _value} ->
      is_nil(user |> Map.get(key)) || key in @vk_priority_fields
    end) |> Map.new
  end
end
