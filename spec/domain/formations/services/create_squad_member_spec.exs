defmodule Squadster.Domain.Formations.Services.CreateSquadMember do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Formations.SquadMember
  alias Squadster.Formations.Services.CreateSquadMember
  alias Squadster.Formations.Tasks.NormalizeQueue

  let :user, do: insert(:user)
  let :squad, do: insert(:squad)

  describe "call/2" do
    before do
      mock NormalizeQueue, :start_link
    end

    it "schedules queue normalization" do
      user() |> CreateSquadMember.call(squad())
      assert_called NormalizeQueue, :start_link
    end

    it "creates a new squad_member" do
      count = entities_count(SquadMember)
      user() |> CreateSquadMember.call(squad())

      %{squad_member: %{squad_id: squad_id}} = user() |> Repo.preload(:squad_member)

      expect entities_count(SquadMember) |> to(eq count + 1)
      expect squad_id |> to(eq squad().id)
    end

    context "when the user already has a squad_member" do
      let! :squad_member, do: insert(:squad_member, user: user())

      it "returns an error with message" do
        {:error, message} = user() |> CreateSquadMember.call(squad())
        expect(is_binary(message)) |> to(eq true)
      end

      it "does not create a new squad_member" do
        count = entities_count(SquadMember)
        user() |> CreateSquadMember.call(squad())
        expect entities_count(SquadMember) |> to(eq count)
      end
    end
  end
end
