defmodule Squadster.Web.Schema.SquadRequestSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  import Mockery

  alias Squadster.Formations.SquadRequest
  alias Squadster.Formations.Tasks.NormalizeQueue

  let :squad, do: insert(:squad)
  let :user, do: insert(:user)

  describe "mutations" do
    describe "create_squad_request" do
      let :create_squad_request, do: %{query: create_squad_request_mutation(), variables: %{squad_id: squad().id}}
      let :create_squad_request_mutation do
        """
          mutation createSquadRequest($squad_id: String) {
            createSquadRequest(squad_id: $squad_id) {
              id
              insertedAt
            }
          }
        """
      end

      it "creates a new squad_request with valid attributes" do
        previous_count = entities_count(SquadRequest)
        api_request(create_squad_request())
        expect entities_count(SquadRequest) |> to(eq previous_count + 1)
      end

      context "when user has a squad" do
        before do
          insert(:squad_member, user: user(), squad: squad())
        end

        it "should return error with message" do
          %{"errors" => [%{"message" => message}]} =
            user()
            |> api_request(create_squad_request())
            |> json_response(200)

          expect message |> to_not(be_nil())
        end
      end
    end

    describe "delete_squad_request" do
      let! :squad_request, do: insert(:squad_request, user: user())
      let :delete_squad_request_mutation do
        """
          mutation deleteSquadRequest($id: Int) {
            deleteSquadRequest(id: $id) {
              insertedAt
            }
          }
        """
      end

      def delete_squad_request(id) do
        %{query: delete_squad_request_mutation(), variables: %{id: id}}
      end

      it "deletes existing squad_request" do
        previous_count = entities_count(SquadRequest)
        user() |> api_request(delete_squad_request(squad_request().id))
        expect entities_count(SquadRequest) |> to(eq previous_count - 1)
      end
    end

    describe "approve_squad_request" do
      let! :squad_request, do: insert(:squad_request, user: insert(:user), squad: squad())
      let :squad, do: build(:squad) |> with_commander(user()) |> insert
      let :approve_squad_request_mutation do
        """
          mutation approveSquadRequest($id: Int) {
            approveSquadRequest(id: $id) {
              id
            }
          }
        """
      end

      def approve_squad_request(id) do
        %{query: approve_squad_request_mutation(), variables: %{id: id}}
      end

      before do
        mock NormalizeQueue, :start_link
      end

      it "approves existing squad_request" do
        expect squad_request().approved_at |> to(eq nil)
        user() |> api_request(approve_squad_request(squad_request().id))
        expect reload(squad_request()).approved_at |> to_not(eq nil)
      end
    end
  end
end
