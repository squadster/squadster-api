defmodule Squadster.Domain.AccountsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model
  use Phoenix.ConnTest

  alias Squadster.Accounts
  alias Squadster.Accounts.User

  let :user, do: insert(:user)

  describe "list_users/0" do
    it "returns list of users" do
      users_count = entities_count(User)
      expect Accounts.list_users()
      |> Enum.count
      |> to(eq users_count)
    end
  end

  describe "find_user/1" do
    it "finds user by id" do
      expect user().id
      |> Accounts.find_user()
      |> to(eq user())
    end
  end

  describe "find_user_by_token/1" do
    it "finds user by token" do
      expect user().auth_token
      |> Accounts.find_user_by_token()
      |> to(eq user())
    end
  end

  describe "find_or_create_user/1" do
    let :auth, do: build(:ueberauth) |> with_uid(user().uid)

    context "when user with given uid present" do
      it "finds user by uid and updates it" do
        {:ok, user} = auth() |> Accounts.find_or_create_user()

        expect user.id |> to(eq user().id)
        expect user.auth_token |> to(eq auth().credentials.token)
      end
    end

    context "when user with given uid does not present" do
      let :new_auth, do: build(:ueberauth) |> with_uid(123)

      it "creates user" do
        initial_count = entities_count(User)
        {:ok, user} = new_auth() |> Accounts.find_or_create_user()
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
