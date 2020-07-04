defmodule Squadster.Web.Schema.SquadMembersSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  import Mockery

  alias Squadster.Formations.SquadMember
  alias Squadster.Formations.Tasks.NormalizeQueue

  #let :create_squad_request_query, do: %{query: create(), variables: %{squad_id: squad().id}}

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
      let :update_params, do: %{id: nil, queue_number: 1, role: "journalist"}

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
    end
  end
end
