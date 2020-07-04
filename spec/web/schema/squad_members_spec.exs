defmodule Squadster.Web.Schema.SquadMembersSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  import Mockery

  alias Squadster.Formations.SquadMember
  alias Squadster.Formations.Tasks.NormalizeQueue

  let :commander, do: insert(:user)
  let :squad, do: build(:squad) |> with_commander(commander()) |> insert
  let :user, do: insert(:user)
  let! :squad_member, do: insert(:squad_member, user: user(), squad: squad())

  describe "mutations" do
    before do
      mock NormalizeQueue, :start_link
    end

    describe "delete_squad_member" do
      let :delete_squad_member_mutation do
        """
          mutation deleteSquadMember($id: Int) {
            deleteSquadMember(id: $id) {
              id
            }
          }
        """
      end

      def delete_squad_member(id) do
        %{query: delete_squad_member_mutation(), variables: %{id: id}}
      end

      it "deletes existing squad_member" do
        previous_count = entities_count(SquadMember)
        user() |> api_request(delete_squad_member(squad_member().id))
        expect entities_count(SquadMember) |> to(eq previous_count - 1)
      end
    end

    describe "update_squad_member" do
      let :update_params, do: %{id: nil, queue_number: 1, role: "journalist"}
      let :update_squad_member_mutation do
        """
          mutation updateSquadMember($id: Int, $queue_number: Int, $role: String) {
            updateSquadMember(id: $id, queueNumber: $queue_number, role: $role) {
              id
              queueNumber
              role
            }
          }
        """
      end

      def update_squad_member(id) do
        params = %{update_params() | id: id}
        %{query: update_squad_member_mutation(), variables: params}
      end

      it "updates a squad_member" do
        commander() |> api_request(update_squad_member(squad_member().id))

        expect Repo.get(SquadMember, squad_member().id).queue_number |> to(eq update_params().queue_number)
        expect {:ok, Repo.get(SquadMember, squad_member().id).role}
        |> to(eq SquadMember.RoleEnum.cast(update_params().role))
      end
    end

    describe "update_squad_members" do
      let :first_member, do: squad_member()
      let :second_user, do: insert(:user)
      let :second_member, do: insert(:squad_member, user: second_user(), squad: squad())

      let :update_params, do: %{first_id: nil, second_id: nil, first_queue_number: 1, second_queue_number: 2}
      let :update_squad_members_mutation do
        """
          mutation updateSquadMembers(
            $first_id: Int,
            $second_id: Int,
            $first_queue_number: Int,
            $second_queue_number: Int
          ) {
            updateSquadMembers(batch: [
              {id: $first_id, queueNumber: $first_queue_number},
              {id: $second_id, queueNumber: $second_queue_number}
            ]) {
              id
              queueNumber
            }
          }
        """
      end

      def update_squad_members(first_id, second_id) do
        params = %{update_params() | first_id: first_id, second_id: second_id}
        %{query: update_squad_members_mutation(), variables: params}
      end

      it "updates queue_numbers for a batch of squad_members" do
        commander() |> api_request(update_squad_members(squad_member().id, second_member().id))

        expect Repo.get(SquadMember, first_member().id).queue_number  |> to(eq update_params().first_queue_number)
        expect Repo.get(SquadMember, second_member().id).queue_number |> to(eq update_params().second_queue_number)
      end
    end
  end
end
