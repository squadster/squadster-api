defmodule Squadster.Accounts.Services.CreateUserSettings do
  alias Squadster.Repo
  alias Squadster.Accounts.UserSettings

  def call(%{id: id} = user) do
    %{settings: settings} = user |> Repo.preload(:settings)
    case settings do
      nil -> create(id)
      _settings -> {:error, "User already has initialized settings"}
    end
  end

  defp create(id) do
    %{user_id: id}
    |> UserSettings.changeset
    |> Repo.insert
  end
end
