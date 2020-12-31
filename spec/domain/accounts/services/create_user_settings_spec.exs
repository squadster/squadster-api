defmodule Squadster.Accounts.Services.CreateUserSettingsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Accounts.UserSettings
  alias Squadster.Accounts.Services.CreateUserSettings

  describe "#call/1" do
    let :user, do: insert(:user)

    subject CreateUserSettings.call(user())

    context "when user doesn't have settings yet" do
      it "create user settings" do
        initial_count = entities_count(UserSettings)

        user()
        |> Repo.preload(:settings)
        |> Map.get(:settings)
        |> Repo.delete

        subject()

        expect initial_count |> to(eq entities_count(UserSettings))
      end
    end

    context "when user doesn't have settings yet" do
      let :user, do: insert(:user)

      it "create user settings" do
        initial_count = entities_count(UserSettings)

        subject()

        expect initial_count |> not_to(eq entities_count(UserSettings))
      end
    end
  end
end
