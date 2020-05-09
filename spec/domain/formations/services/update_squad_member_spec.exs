defmodule Squadster.Domain.Services.UpdateSquadMemberSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Formations.SquadMember
  alias Squadster.Formations.Services.UpdateSquadMember

  let :user, do: insert(:user)
  let :squad, do: build(:squad) |> with_commander(user()) |> insert
  let :squad_member, do: insert(:squad_member, user: insert(:user), squad: squad())

  describe "call/2" do
    context "when one squad_member given" do
      let :args, do: %{role: "journalist"}

      it "updates the squad_member" do
        squad_member() |> UpdateSquadMember.call(args())
        updated = SquadMember |> Repo.get(squad_member().id)
        expect(updated.role) |> to(eq :journalist)
      end

      context "when updating role to commander" do
        let :args, do: %{role: "commander"}

        it "demotes old commander" do
          squad_member() |> UpdateSquadMember.call(args())
          %{squad_member: %{role: role}} = user() |> Repo.preload(:squad_member)
          expect(role) |> to(eq :student)
        end

        it "updates the squad_member" do
          squad_member() |> UpdateSquadMember.call(args())
          updated = SquadMember |> Repo.get(squad_member().id)
          expect(updated.role) |> to(eq :commander)
        end
      end
    end

    context "when batch of squad_members given" do

    end
  end
end
