defmodule Squadster.Domain.FormationsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Formations
  alias Squadster.Formations.{Squad, SquadRequest}

  let :user, do: insert(:user)

  describe "list_squads/0" do
    it "returns list of squads" do
      squads_count = entities_count(Squad)
      expect Formations.list_squads()
      |> Enum.count
      |> to(eq squads_count)
    end
  end

  describe "create_squad/2" do
    let :create_params, do: %{squad_number: "123456", class_day: 3}

    it "returns new squad" do
      {:ok, squad} = Formations.create_squad(create_params(), user())
      expect(squad.__struct__) |> to(eq Squadster.Formations.Squad)
    end
  end

  describe "delete_squad/2" do
    it "deletes a squad by id" do
      %{id: squad_id} = build(:squad) |> with_commander(user()) |> insert
      previous_count = entities_count(Squad)

      Formations.delete_squad(squad_id, user())

      expect entities_count(Squad) |> to(eq previous_count - 1)
    end
  end

  describe "update_squad/2" do
    let :squad, do: build(:squad) |> with_commander(user()) |> insert
    let :update_params, do: %{
      id: squad().id,
      squad_number: "123456",
      advertisment: "~\-o-/~  <  wub-wub-wub",
      class_day: 4
    }

    it "updates a squad by id" do
      Formations.update_squad(update_params(), user())

      expect Repo.get(Squad, squad().id).advertisment |> to(eq update_params().advertisment)
      expect {:ok, Repo.get(Squad, squad().id).class_day} |> to(eq Squad.ClassDayEnum.cast(update_params().class_day))
      expect Repo.get(Squad, squad().id).squad_number |> to(eq update_params().squad_number)
    end
  end

  describe "create_squad_request/2" do
    let :squad, do: insert(:squad)

    it "creates a new squad_request" do
      previous_count = entities_count(SquadRequest)
      Formations.create_squad_request(squad().id, user())
      expect entities_count(SquadRequest) |> to(eq previous_count + 1)
    end

    context "when user has another request" do
      it "should delete old request and create new one" do
        count = entities_count(SquadRequest)
        {:ok, %{id: id}} = Formations.create_squad_request(squad().id, user())

        expect entities_count(SquadRequest) |> to(eq count + 1)

        count = entities_count(SquadRequest)
        {:ok, %{id: new_id}} = Formations.create_squad_request(squad().id, user())

        expect entities_count(SquadRequest) |> to(eq count)
        expect new_id |> to_not(eq id)
      end
    end

    context "when user has a squad" do
      before do
        insert(:squad_member, user: user(), squad: squad())
      end

      it "should not create request" do
        initial_count = entities_count(SquadRequest)

        Formations.create_squad_request(squad().id, user())

        expect entities_count(SquadRequest) |> to(eq initial_count)
      end

      it "should return error with message" do
        {:error, message} = Formations.create_squad_request(squad().id, user())
        expect message |> to_not(be_nil())
      end
    end

    describe "delete_squad_request/2" do
      let! :squad_request, do: insert(:squad_request, user: user())

      it "deletes existing squad_request" do
        previous_count = entities_count(SquadRequest)
        Formations.delete_squad_request(squad_request().id, user())
        expect entities_count(SquadRequest) |> to(eq previous_count - 1)
      end
    end

    describe "approve_squad_request/2" do
      let! :squad_request, do: insert(:squad_request, user: insert(:user), squad: squad())
      let :squad, do: build(:squad) |> with_commander(user()) |> insert

      context "when user has enough permissions" do
        it "returns new squad_member" do
          {:ok, squad_member} = Formations.approve_squad_request(squad_request().id, user())
          expect(squad_member.__struct__) |> to(eq Squadster.Formations.SquadMember)
        end
      end

      context "when user does not have enough permissions" do
        let :squad, do: insert(:squad)

        it "returns error" do
          {:error, message} = Formations.approve_squad_request(squad_request().id, user())
          expect message |> to_not(be nil)
        end
      end
    end
  end
end
