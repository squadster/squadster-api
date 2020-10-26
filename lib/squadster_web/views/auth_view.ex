defmodule SquadsterWeb.AuthView do
  use SquadsterWeb, :view

  def render("callback.json", %{user: user}) do
    user |> Map.take(Squadster.Accounts.User.user_fields)
  end
end
