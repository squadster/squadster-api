defmodule Squadster.Web.AuthViewSpec do
  use ESpec.Phoenix, async: true, view: AuthView
  use ESpec.Phoenix.Extend, :view

  describe "callback.json" do
    let :user, do: insert(:user)
    let :content do
      render(SquadsterWeb.AuthView, "callback.json", user: user(), show_info: true)
    end

    it "renders user info" do
      %{user: user} = content()
      expect user |> to(eq(user() |> Map.take(Squadster.Accounts.User.user_fields)))
    end

    it "renders show_info" do
      %{show_info: show_info} = content()
      expect show_info |> to(eq true)
    end
  end
end
