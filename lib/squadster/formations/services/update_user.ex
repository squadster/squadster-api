defmodule Squadster.Formations.Services.UpdateUser do
  alias Squadster.Repo
  alias Squadster.Accounts.User

  def call(user, args) do
    user
    |> User.changeset(args)
    |> Repo.update
  end
end
