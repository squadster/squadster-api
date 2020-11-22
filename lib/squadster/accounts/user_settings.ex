defmodule Squadster.Accounts.UserSettings do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Repo

  @validating_fields [
    :vk_notifications_enabled,
    :telegram_notifications_enabled,
    :email_notifications_enabled,
    :user_id
  ]

  schema "user_settings" do
    field :vk_notifications_enabled, :boolean
    field :telegram_notifications_enabled, :boolean
    field :email_notifications_enabled, :boolean
    belongs_to :user, Squadster.Accounts.User
  end

  def changeset(params) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @validating_fields)
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
  end
end
