defmodule Squadster.Web.Resolvers.Accounts do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  import Mockery.Assertions

  alias SquadsterWeb.Resolvers.Accounts
  alias Squadster.Accounts.User

  describe "find_user/3" do
    context "when the user exists" do
      let! :user, do: insert(:user)

      it "returns user" do
        {:ok, user} = Accounts.find_user(nil, %{id: user().id}, nil)
        expect user |> to(eq user())
      end
    end

    context "when the user does not exist" do
      it "returns error" do
        {:error, message} = Accounts.find_user(nil, %{id: 1}, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "list_users/3" do
    let! :users, do: insert_list(3, :user)

    it "returns users" do
      {:ok, users} = Accounts.list_users(nil, nil, nil)
      expect Enum.count(users) |> to(eq entities_count(User))
    end
  end

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

  describe "update_user/3" do
    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Accounts.update_user/2" do
        Accounts.update_user(nil, %{first_name: "Salvador"}, %{context: %{current_user: user()}})
        assert_called Squadster.Accounts, :update_user
      end
    end

    context "when the user is not logged in" do
      it "returns error" do
        {:error, message} = Accounts.update_user(nil, nil, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end
end
