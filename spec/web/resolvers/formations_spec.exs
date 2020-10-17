defmodule Squadster.Web.Resolvers.FormationsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias SquadsterWeb.Resolvers.Formations
  alias Squadster.Formations.Squad

  describe "squad/3" do
    context "when the squad exists" do
      let! :squad, do: insert(:squad)

      it "returns squad" do
        {:ok, squad} = Formations.squad(nil, %{squad_number: squad().squad_number}, nil)
        expect squad |> to(eq squad())
      end
    end

    context "when the squad does not exist" do
      it "returns error" do
        {:error, message} = Formations.squad(nil, %{squad_number: "123456"}, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "squads/3" do
    let! :squads, do: insert_list(3, :squad)

    it "returns squads" do
      {:ok, squads} = Formations.squads(nil, nil, nil)
      expect Enum.count(squads) |> to(eq entities_count(Squad))
    end
  end

  describe "create_squad/3" do
    let :squad_args, do: %{squad_number: "123456", class_day: :friday}

    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Formations.create_squad/2" do
        Formations.create_squad(nil, squad_args(), %{context: %{current_user: user()}})
        assert_called Squadster.Formations, :create_squad
      end
    end

    context "when the user is not logged in" do
      it "returns an error" do
        {:error, message} = Formations.create_squad(nil, squad_args(), nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "update_squad/3" do
    let! :squad, do: insert(:squad, squad_number: "111222")
    let :squad_args, do: %{id: squad().id, squad_number: "123456"}

    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Formations.update_squad/2" do
        mock Squadster.Formations, :update_squad
        Formations.update_squad(nil, squad_args(), %{context: %{current_user: user()}})
        assert_called Squadster.Formations, :update_squad
      end
    end

    context "when the user is not logged in" do
      it "returns an error" do
        {:error, message} = Formations.update_squad(nil, squad_args(), nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "delete_squad/3" do
    let! :squad, do: insert(:squad)

    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Formations.delete_squad/2" do
        Formations.delete_squad(nil, %{id: squad().id}, %{context: %{current_user: user()}})
        assert_called Squadster.Formations, :delete_squad
      end
    end

    context "when the user is not logged in" do
      it "returns an error" do
        {:error, message} = Formations.delete_squad(nil, %{id: squad().id}, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "create_squad_request/3" do
    let! :squad, do: insert(:squad)

    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Formations.create_squad_request/2" do
        Formations.create_squad_request(nil, %{squad_id: squad().id}, %{context: %{current_user: user()}})
        assert_called Squadster.Formations, :create_squad_request
      end
    end

    context "when the user is not logged in" do
      it "returns an error" do
        {:error, message} = Formations.create_squad_request(nil, %{squad_id: squad().id}, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "approve_squad_request/3" do
    let! :squad_request, do: insert(:squad_request)

    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Formations.create_squad_request/2" do
        Formations.approve_squad_request(nil, %{id: squad_request().id}, %{context: %{current_user: user()}})
        assert_called Squadster.Formations, :approve_squad_request
      end
    end

    context "when the user is not logged in" do
      it "returns an error" do
        {:error, message} = Formations.approve_squad_request(nil, %{id: squad_request().id}, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "delete_squad_request/3" do
    let! :squad_request, do: insert(:squad_request)

    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Formations.delete_squad_request/2" do
        Formations.delete_squad_request(nil, %{id: squad_request().id}, %{context: %{current_user: user()}})
        assert_called Squadster.Formations, :delete_squad_request
      end
    end

    context "when the user is not logged in" do
      it "returns an error" do
        {:error, message} = Formations.delete_squad_request(nil, %{id: squad_request().id}, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "update_squad_member/3" do
    let! :squad_member, do: insert(:squad_request)
    let :squad_member_params, do: %{id: squad_member().id, queue_number: 1}

    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Formations.update_squad_member/2" do
        mock Squadster.Formations, :update_squad_member
        Formations.update_squad_member(nil, squad_member_params(), %{context: %{current_user: user()}})
        assert_called Squadster.Formations, :update_squad_member
      end
    end

    context "when the user is not logged in" do
      it "returns an error" do
        {:error, message} = Formations.update_squad_member(nil, squad_member_params(), nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "delete_squad_member/3" do
    let! :squad_member, do: insert(:squad_request)
    let :squad_member_params, do: %{id: squad_member().id, queue_number: 1}

    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Formations.delete_squad_member/2" do
        mock Squadster.Formations, :delete_squad_member
        Formations.delete_squad_member(nil, %{id: squad_member().id}, %{context: %{current_user: user()}})
        assert_called Squadster.Formations, :delete_squad_member
      end
    end

    context "when the user is not logged in" do
      it "returns an error" do
        {:error, message} = Formations.delete_squad_member(nil, %{id: squad_member().id}, nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end

  describe "update_squad_members/3" do
    let! :first_member, do: insert(:squad_request)
    let! :second_member, do: insert(:squad_request)
    let :squad_members_params do
      %{batch: [
        %{id: first_member().id, queue_number: 1},
        %{id: second_member().id, queue_number: 2}
      ]}
    end

    context "when the user is logged in" do
      let! :user, do: insert(:user)

      it "calls Formations.bulk_update_squad_members/2" do
        mock Squadster.Formations, :bulk_update_squad_members, nil
        Formations.update_squad_members(nil, squad_members_params(), %{context: %{current_user: user()}})
        assert_called Squadster.Formations, :bulk_update_squad_members
      end

      context "when the service returns nil" do
        it "returns an error" do
          mock Squadster.Formations, :bulk_update_squad_members, nil
          {:error, message} = Formations.update_squad_members(nil, squad_members_params(), %{context: %{current_user: user()}})
          expect is_binary(message) |> to(be true)
        end
      end

      context "when the service returns :ok" do
        it "returns a list of updated squad members" do
          mock Squadster.Formations, :bulk_update_squad_members, {:ok, [{1, first_member()}, {2, second_member()}]}
          {:ok, result} = Formations.update_squad_members(nil, squad_members_params(), %{context: %{current_user: user()}})
          expect is_list(result) |> to(be true)
          expect Enum.count(result) |> to(eq Enum.count(squad_members_params().batch))
        end
      end
    end

    context "when the user is not logged in" do
      it "returns an error" do
        {:error, message} = Formations.update_squad_members(nil, squad_members_params(), nil)
        expect is_binary(message) |> to(be true)
      end
    end
  end
end
