defmodule Squadster.Domain.Formations.Services.UpdateSquadMemberSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Formations.Services.UpdateSquadMember
  alias Squadster.Formations.Tasks.NormalizeQueue

  let :user, do: insert(:user)
  let :squad, do: build(:squad) |> with_commander(user()) |> insert
  let :squad_member, do: insert(:squad_member, user: insert(:user), squad: squad())

  describe "call/2" do
    before do
      mock NormalizeQueue, :start_link
    end

    context "when one squad_member given" do
      let :args, do: %{role: "journalist"}

      it "updates the squad_member" do
        squad_member() |> UpdateSquadMember.call(args())
        expect(reload(squad_member()).role) |> to(eq :journalist)
      end

      it "schedules queue normalization" do
        squad_member() |> UpdateSquadMember.call(args())
        assert_called NormalizeQueue, :start_link
      end

      context "when updating role to commander" do
        let :args, do: %{id: squad_member().id, role: "commander"}

        it "demotes old commander" do
          squad_member() |> UpdateSquadMember.call(args())
          %{squad_member: %{role: role}} = user() |> Repo.preload(:squad_member)
          expect(role) |> to(eq :student)
        end

        it "updates the squad_member" do
          squad_member() |> UpdateSquadMember.call(args())
          expect(reload(squad_member()).role) |> to(eq :commander)
        end
      end
    end

    context "when batch of squad_members given" do
      let :first_member,  do: insert(:squad_member, user: insert(:user), squad: squad())
      let :second_member, do: insert(:squad_member, user: insert(:user), squad: squad())
      let :members, do: [first_member(), second_member()]
      let :args do
        [
          %{id:  first_member().id |> Integer.to_string, queue_number: 1},
          %{id: second_member().id |> Integer.to_string, queue_number: 2}
        ]
      end

      it "updates the squad_members" do
        members() |> UpdateSquadMember.call(args())

        first  = reload(first_member())
        second = reload(second_member())
        expect(first.queue_number) |> to(eq 1)
        expect(second.queue_number) |> to(eq 2)
      end
    end
  end
end
