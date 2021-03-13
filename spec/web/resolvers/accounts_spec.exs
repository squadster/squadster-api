defmodule Squadster.Web.Resolvers.AccountsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery.Assertions

  alias SquadsterWeb.Resolvers.Accounts

  describe "current_user/3" do
    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "returns current user" do
        {:ok, user} = Accounts.current_user(nil, nil, %{context: %{current_user: user()}})
        expect user |> to(eq user())
      end
    end

    context "when the user is not logged in" do
      it "returns error" do
        {:error, message} = Accounts.current_user(nil, nil, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "update_current_user/3" do
    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Accounts.update_user/2" do
        Accounts.update_current_user(nil, %{first_name: "Salvador"}, %{context: %{current_user: user()}})
        assert_called Squadster.Accounts, :update_user
      end
    end

    context "when the user is not logged in" do
      it "returns error" do
        {:error, message} = Accounts.update_current_user(nil, nil, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "update_user_settings/3" do
    context "when uer is logged in" do
      let! :user, do: insert(:user)
      let :user_settings_params, do: %{vk_notifications_enabled: false}

      it "calls Account.update_user_settings/2" do
        Accounts.update_user_settings(nil, user_settings_params(), %{context: %{current_user: user()}})
        assert_called Squadster.Accounts, :update_user_settings
      end
    end

    context "when the user is not logged in" do
      it "doesn't call Accounts.update_user_settings/2" do
        Accounts.update_user_settings(nil, nil, nil)
        refute_called Squadster.Accounts, :update_user_settings
      end
    end
  end
end
