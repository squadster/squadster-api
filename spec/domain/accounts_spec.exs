defmodule Squadster.Domain.AccountsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Plug.Conn
  import Phoenix.ConnTest

  alias Squadster.Accounts
  alias Squadster.Accounts.User
  alias Squadster.Accounts.UserSettings

  let :user, do: insert(:user)

  describe "#update_user_settings/2" do
    let :user_settings_params, do: %{
      vk_notifications_enabled: false,
      telegram_notifications_enabled: false,
      email_notifications_enabled: false,
    }

    let :user, do: insert(:user)
    let :user_settings, do: build(:user_settings) |> with_user(user()) |> insert

    it "updates user settings" do
      Accounts.update_user_settings(user_settings_params(), user())

      %{settings: updated_user_settings} = reload(user()) |> Repo.preload(:settings)

      expect updated_user_settings.vk_notifications_enabled |> to(eq user_settings_params().vk_notifications_enabled)
      expect updated_user_settings.email_notifications_enabled |> to(eq user_settings_params().email_notifications_enabled)
      expect updated_user_settings.telegram_notifications_enabled |> to(eq user_settings_params().telegram_notifications_enabled)
    end
  end

  describe "find_user_by_token/1" do
    it "finds user by token" do
      expect user().auth_token
      |> Accounts.find_user_by_token()
      |> Map.get(:id)
      |> to(eq user().id)
    end
  end

  describe "find_or_create_user/1" do
    let :auth, do: build(:ueberauth) |> with_uid(user().uid)

    context "when user with given uid present" do
      it "finds user by uid and updates it" do
        {:found, user} = auth() |> Accounts.find_or_create_user()

        expect user.id |> to(eq user().id)
      end

      #it "should not update auth_token" do
        #{:found, user} = auth() |> Accounts.find_or_create_user()

        #expect user.auth_token |> to(eq user().auth_token)
      #end
    end

    context "when user with given uid does not present" do
      let :new_auth, do: build(:ueberauth) |> with_uid(123)

      it "creates user" do
        initial_count = entities_count(User)
        {:created, user} = new_auth() |> Accounts.find_or_create_user()
        expect initial_count |> to_not(eq entities_count(User))
        expect user.id |> to_not(eq user().id)
      end
    end
  end

  describe "current_user/1" do
    it "returns current_user from conn" do
      conn = build_conn() |> assign(:current_user, user())

      expect conn
      |> Accounts.current_user
      |> to(eq user())
    end
  end

  describe "signed_in?/1" do
    context "when conn contains current_user" do
      it "returns true" do
        conn = build_conn() |> assign(:current_user, user())

        expect conn
        |> Accounts.signed_in?
        |> to(be true)
      end
    end

    context "when conn does not contains current_user" do
      it "returns false" do
        expect build_conn()
        |> Accounts.signed_in?
        |> to(be false)
      end
    end
  end

  describe "logout/1" do
    it "sets current_user's auth_token to nil" do
      {:ok, %{auth_token: token}} =
        build_conn()
        |> assign(:current_user, user())
        |> Accounts.logout

      expect token |> to(be nil)
    end
  end
end
