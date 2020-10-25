defmodule Squadster.Accounts do
  import Ecto.Changeset

  alias Ueberauth.Auth
  alias Squadster.Repo
  alias Squadster.Accounts.User
  alias Squadster.Accounts.Services.UpdateUser

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

  def find_or_create_user(%Auth{} = auth) do
    if user = User |> Repo.get_by(uid: User.uid_from_auth(auth)) do
      user
      |> User.auth_changeset(User.data_from_auth(auth))
      |> delete_change(:uid)
      |> Repo.update
    else
      auth
      |> User.data_from_auth
      |> User.auth_changeset
      |> Repo.insert
    end
  end

  def update_user(args, user) do
    # TODO: permissions
    user |> UpdateUser.call(args)
  end
end
