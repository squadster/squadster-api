defmodule Squadster.Support.Factory.Accounts.UserSettingsFactory do
  defmacro __using__(_opts) do
    quote do
      def user_settings_factory do
        %Squadster.Accounts.UserSettings{
          vk_notifications_enabled: true,
          telegram_notifications_enabled: false,
          email_notifications_enabled: false
        }
      end

      def with_user(user_settings, user) do
        %{user_settings | user: user}
      end
    end
  end
end
