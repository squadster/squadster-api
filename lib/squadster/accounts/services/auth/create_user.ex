defmodule Squadster.Accounts.Services.Auth.CreateUser do
  alias Squadster.Repo
  alias Squadster.Accounts.User
  alias Squadster.Accounts.Services.CreateUserSettings

  def call(auth_args) do
    auth_args
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
