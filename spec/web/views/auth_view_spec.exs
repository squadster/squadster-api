defmodule Squadster.Web.AuthViewSpec do
  use ESpec.Phoenix, async: true, view: AuthView
  use ESpec.Phoenix.Extend, :view

  describe "callback.json" do
    let :user, do: insert(:user)
    let :content do
      render(SquadsterWeb.AuthView, "callback.json", user: user())
    end

    it "renders json" do
      %{user: user} = content()
      expect user |> to(eq(user() |> Map.take(Squadster.Accounts.User.user_fields)))
    end
  end
end
