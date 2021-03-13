defmodule Squadster.Domain.Services.UpdateUserSettingsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Accounts.Services.UpdateUserSettings

  let :user, do: insert(:user)
  let :update_params, do: %{
    vk_notifications_enabled: false,
    telegram_notifications_enabled: true,
    email_notifications_enabled: true,
  }

  before do: user() |> Repo.preload(:settings)

  describe "#call/2" do
    it "updates user settings" do
      UpdateUserSettings.call(update_params(), user().settings)

      %{settings: settings} = reload(user()) |> Repo.preload(:settings)

      expect settings.vk_notifications_enabled |> to(eq update_params().vk_notifications_enabled)
      expect settings.email_notifications_enabled |> to(eq update_params().email_notifications_enabled)
      expect settings.telegram_notifications_enabled |> to(eq update_params().telegram_notifications_enabled)
    end
  end
end
