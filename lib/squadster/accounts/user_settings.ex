defmodule Squadster.Accounts.UserSettings do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Repo

  @cast_fields [
    :vk_notifications_enabled,
    :telegram_notifications_enabled,
    :email_notifications_enabled,
  ]

  schema "user_settings" do
    field :vk_notifications_enabled, :boolean, default: true
    field :telegram_notifications_enabled, :boolean, default: false
    field :email_notifications_enabled, :boolean, default: false
    belongs_to :user, Squadster.Accounts.User
  end

  def changeset(params) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @cast_fields)
    |> validate_required(@cast_fields)
  end
end
