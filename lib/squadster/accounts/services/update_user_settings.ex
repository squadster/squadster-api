defmodule Squadster.Accounts.Services.UpdateUserSettings do
  alias Squadster.Repo
  alias Squadster.Accounts.UserSettings

  def call(args, settings) do
    settings
    |> UserSettings.changeset(args)
    |> Repo.update
  end
end
