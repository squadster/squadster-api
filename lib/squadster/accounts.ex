defmodule Squadster.Accounts do
  alias Ueberauth.Auth
  alias Squadster.Repo
  alias Squadster.Accounts.User
  alias Squadster.Accounts.Services.{
    UpdateUser,
    CreateUserSettings,
    UpdateUserSettings
  }
  alias Squadster.Helpers.Permissions

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params), do: queryable

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def signed_in?(conn) do
    !!current_user(conn)
  end

  def logout(conn) do
    conn
    |> current_user
    |> User.auth_changeset(%{auth_token: nil})
    |> Repo.update
  end

  def find_user_by_token(token) do
    User |> Repo.get_by(auth_token: token)
  end

  def update_user_settings(%{user_id: id} = args, current_user) do
    target_user = User |> Repo.get(id) |> Repo.preload(:settings)
    if current_user |> Permissions.can_update?(target_user) do
      args |> UpdateUserSettings.call(target_user.settings)
    else
      {:error, "Not enough permissions"}
    end
  end

  def find_or_create_user(%Auth{} = auth) do
    if user = User |> Repo.get_by(uid: User.uid_from_auth(auth)) do
      user
      |> User.auth_changeset(User.data_from_auth(auth))
      |> Repo.update
      |> case do
        {:ok, user}      ->
          user |> CreateUserSettings.call
          {:found, user}
        {:error, reason} -> {:error, reason}
      end
    else
      auth
      |> User.data_from_auth
      |> User.auth_changeset
      |> Repo.insert
      |> case do
        {:ok, user} ->
          user |> CreateUserSettings.call
          {:created, user}
        {:error, reason} -> {:error, reason}
      end
    end
  end

  def update_user(args, user) do
    user |> UpdateUser.call(args)
  end
end
