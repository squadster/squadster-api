defmodule Squadster.Web.Schema.SquadMembersSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  import Mockery

  alias Squadster.Formations.SquadMember
  alias Squadster.Formations.Tasks.NormalizeQueue

  let :delete do
    """
      mutation deleteSquadMember($id: Int) {
        deleteSquadMember(id: $id) {
          id
        }
      }
    """
  end

  let :update do

  end

  let :update_batch do
    """
      mutation approveSquadRequest($id: Int) {
        approveSquadRequest(id: $id) {
          id
        }
      }
    """
  end

  #let :create_squad_request_query, do: %{query: create(), variables: %{squad_id: squad().id}}

  let :squad, do: insert(:squad)
  let :user, do: insert(:user)

  def delete_squad_member_query(id) do
    %{query: delete(), variables: %{id: id}}
  end

  describe "mutations" do
    before do
      mock NormalizeQueue, :start_link
    end

    describe "delete_squad_member" do
      let! :squad_member, do: insert(:squad_member, user: user(), squad: squad())

      it "deletes existing squad_member" do
        previous_count = entities_count(SquadMember)
        user() |> api_request(delete_squad_member_query(squad_member().id))
        expect entities_count(SquadMember) |> to(eq previous_count - 1)
      end
    end

    describe "update_squad_member" do
    end
  end
end
