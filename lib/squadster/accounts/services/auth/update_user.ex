defmodule Squadster.Accounts.Services.Auth.UpdateUser do
  import Mockery.Macro

  alias Ecto.Changeset
  alias Squadster.Repo
  alias Squadster.Accounts.User

  def call(user, auth_args) do
    user
    |> mockable(User).auth_changeset(User.data_from_auth(auth_args))
    #|> Changeset.delete_change(:auth_token)
    |> Repo.update
    |> case do
      {:ok, user}      -> {:found, user}
      {:error, reason} -> {:error, reason}
    end
  end
end
