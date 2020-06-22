defmodule Squadster.Web.Schema.SquadRequestSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  import Mockery

  alias Squadster.Formations.SquadRequest
  alias Squadster.Formations.Tasks.NormalizeQueue

  let :create do
    """
      mutation createSquadRequest($squad_id: String) {
        createSquadRequest(squad_id: $squad_id) {
          id
          insertedAt
        }
      }
    """
  end

  let :delete do
    """
      mutation deleteSquadRequest($id: Int) {
        deleteSquadRequest(id: $id) {
          insertedAt
        }
      }
    """
  end

  let :approve do
    """
      mutation approveSquadRequest($id: Int) {
        approveSquadRequest(id: $id) {
          id
        }
      }
    """
  end

  let :create_squad_request_query, do: %{query: create(), variables: %{squad_id: squad().id}}

  let :squad, do: insert(:squad)
  let :user, do: insert(:user)

  def delete_squad_request_query(id) do
    %{query: delete(), variables: %{id: id}}
  end

  def approve_squad_request_query(id) do
    %{query: approve(), variables: %{id: id}}
  end

  describe "mutations" do
    context "create_squad_request" do
      it "creates a new squad_request with valid attributes" do
        previous_count = entities_count(SquadRequest)
        api_request(create_squad_request_query())
        expect entities_count(SquadRequest) |> to(eq previous_count + 1)
      end

      context "when user has a squad" do
        before do
          insert(:squad_member, user: user(), squad: squad())
        end

        it "should return error with message" do
          %{"errors" => [%{"message" => message}]} =
            user()
            |> api_request(create_squad_request_query())
            |> json_response(200)

          expect message |> to_not(be_nil())
        end
      end
    end

    context "delete_squad_request" do
      let! :squad_request, do: insert(:squad_request, user: user())

      it "deletes existing squad_request" do
        previous_count = entities_count(SquadRequest)
        user() |> api_request(delete_squad_request_query(squad_request().id))
        expect entities_count(SquadRequest) |> to(eq previous_count - 1)
      end
    end

    context "approve_squad_request" do
      let! :squad_request, do: insert(:squad_request, user: insert(:user), squad: squad())
      let :squad, do: build(:squad) |> with_commander(user()) |> insert

      before do
        mock NormalizeQueue, :start_link
      end

      it "approves existing squad_request" do
        expect squad_request().approved_at |> to(eq nil)

        user() |> api_request(approve_squad_request_query(squad_request().id))
        request = SquadRequest |> Repo.get(squad_request().id)

        expect request.approved_at |> to_not(eq nil)
      end
    end
  end
end
