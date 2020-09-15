defmodule Squadster.Domain.Formations.Services.DeleteSquadMemberSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Formations.{SquadMember, SquadRequest}
  alias Squadster.Formations.Services.DeleteSquadMember
  alias Squadster.Formations.Tasks.NormalizeQueue

  let :user, do: insert(:user)
  let :squad, do: insert(:squad)
  let! :squad_member, do: insert(:squad_member, user: user(), squad: squad())

  describe "call/2" do
    before do
      mock NormalizeQueue, :start_link
    end

    it "deletes squad_member" do
      initial_count = entities_count(SquadMember)
      squad_member() |> DeleteSquadMember.call
      expect(entities_count(SquadMember)) |> to(eq initial_count - 1)
    end

    it "schedules queue normalization" do
      squad_member() |> DeleteSquadMember.call
      assert_called NormalizeQueue, :start_link
    end

    context "when user has squad_request" do
      let! :squad_request, do: insert(:squad_request, user: user(), squad: squad())

      it "deletes squad_request" do
        initial_count = entities_count(SquadRequest)
        squad_member() |> DeleteSquadMember.call
        expect(entities_count(SquadRequest)) |> to(eq initial_count - 1)
      end

      it "deletes squad_member" do
        initial_count = entities_count(SquadMember)
        squad_member() |> DeleteSquadMember.call
        expect(entities_count(SquadMember)) |> to(eq initial_count - 1)
      end
    end
  end
end
