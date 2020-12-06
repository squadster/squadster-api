defmodule Squadster.Accounts.Tasks.Notify do
  use Task

  import Mockery.Macro

  alias Squadster.Formations.Squad
  alias Squadster.Formations.SquadMember
  alias Squadster.Accounts.User
  alias Squadster.Mailer
  alias Squadster.Mailer.Emails.NotifyEmail
  alias Squadster.Repo

  @bot_endpoint Application.fetch_env!(:squadster, :bot_url) <> "/message"
  @bot_token "ApiKey " <> Application.fetch_env!(:squadster, :bot_token)
  @request_headers [{"content-type", "application/json"}, {"Authorization", @bot_token}]
  @settings_fields [:vk_notifications_enabled, :telegram_notifications_enabled, :email_notifications_enabled]

  def start_link(args) do
    Task.start_link(__MODULE__, :notify, [args])
  end

  def notify([message: message, target: target]), do: message |> send_to(target)
  def notify([message: message, target: target, options: options]), do: message |> send_to(target, options)

  defp send_to(message, %User{} = user) do
    user_with_settings = user |> Repo.preload(:settings)

    if user_with_settings.settings.email_notifications_enabled and user.email do
      user.email
      |> mockable(Mailer).send("Squadster notification",
                     NotifyEmail.html_template(message, user),
                     NotifyEmail.text_template(message, user))
    end

    mockable(HTTPoison).post @bot_endpoint, request_body(message, user_with_settings), @request_headers
  end

  defp send_to(message, %SquadMember{user_id: user_id}) do
    message |> send_to(User |> Repo.get(user_id))
  end

  defp send_to(message, %Squad{} = squad, options \\ []) do
    defaults = [skip_commander: false, skip_deputy: false, skip_journalist: false, skip: []]
    options = Keyword.merge(defaults, options) |> Enum.into(%{})

    squad
    |> Ecto.assoc(:members)
    |> Repo.all
    |> Enum.reject(fn member -> member.user_id in options[:skip] end)
    |> Enum.reject(fn member -> options[:skip_commander] && member.role == :commander end)
    |> Enum.reject(fn member -> options[:skip_deputy] && member.role == :deputy_commander end)
    |> Enum.reject(fn member -> options[:skip_journalist] && member.role == :journalist end)
    |> Enum.each(fn member -> message |> send_to(member) end)
  end

  defp request_body(message, %User{id: id, settings: settings}) do
    """
      {
        "text": "#{message}",
        "target": #{id},
        "channels": #{settings |> user_notification_channels |> Poison.encode!}
      }
    """
  end

  defp user_notification_channels(settings) do
    @settings_fields
    |> Enum.map(fn field ->
      if settings |> Map.get(field) do
        [channel | _] = field |> Atom.to_string |> String.split("_")
        channel
      end
    end)
    |> Enum.filter(fn channel -> !is_nil(channel) end)
  end
end
