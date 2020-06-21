defmodule Squadster.Helpers.Messages do
  alias Squadster.Formations.Squad
  alias Squadster.Formations.SquadMember
  alias Squadster.Accounts.User
  alias Squadster.Repo

  @bot_endpoint Application.fetch_env!(:squadster, :bot_url) <> "/message"
  @bot_token "ApiKey " <> Application.fetch_env!(:squadster, :bot_token)
  @request_headers [{"content-type", "application/json"}, {"Authorization", @bot_token}]

  def send_to(message, %User{id: id}) do
    HTTPoison.post @bot_endpoint, request_body(message, id), @request_headers
  end

  def send_to(message, %SquadMember{user_id: user_id}) do
    message |> send_to(User |> Repo.get(user_id))
  end

  def send_to(message, %Squad{} = squad, skip_commander \\ false, skip_deputy \\ false, skip_journalist \\ false) do
    squad
    |> Ecto.assoc(:members)
    |> Repo.all
    |> Enum.reject(fn member -> skip_commander && member.role == :commander end)
    |> Enum.reject(fn member -> skip_deputy && member.role == :deputy_commander end)
    |> Enum.reject(fn member -> skip_journalist && member.role == :journalist end)
    |> Enum.each(fn member -> message |> send_to(member) end)
  end

  defp request_body(message, user_id) do
    """
      {
        "text": "#{message}",
        "target": #{user_id}
      }
    """
  end
end
