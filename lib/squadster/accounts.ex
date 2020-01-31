defmodule Squadster.Accounts do
  import Ecto.Changeset

  alias Ueberauth.Auth
  alias Squadster.Repo
  alias Squadster.Accounts.User

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def signed_in?(conn) do
    !!current_user(conn)
  end

  def logout(conn) do
    conn
    |> current_user
    |> User.auth_changeset
    |> put_change(:auth_token, nil)
    |> Repo.update
  end

  def list_users do
    {:ok, Repo.all(User)}
  end

  def find_user(id) do
    Repo.get_by(User, id: id)
  end

  def find_user_by_token(token) do
    Repo.get_by(User, auth_token: token)
  end

  def find_or_create_user(%Auth{} = auth) do
    if user = Repo.get_by(User, uid: User.uid_from_auth(auth)) do
      user
      |> User.auth_changeset(User.data_from_auth(auth))
      |> delete_change(:uid)
      |> Repo.update
    else
      Repo.insert(User.auth_changeset(User.data_from_auth(auth)))
    end
  end
end
