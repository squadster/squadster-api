defmodule SquadsterWeb.AuthView do
  use SquadsterWeb, :view

  def render("callback.json", %{user: user, show_info: show_info}) do
    %{
      user: user |> Map.take(Squadster.Accounts.User.user_fields),
      show_info: show_info
    }
  end
end
