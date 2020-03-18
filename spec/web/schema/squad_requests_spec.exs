defmodule Squadster.Web.Schema.SquadRequestSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller
  use Phoenix.ConnTest

  import Squadster.Support.Factory

  alias Squadster.Formations.SquadRequest

  let :create do
    """
      mutation createSquadRequest($squad_id: String) {
        createSquadRequest(squad_id: $squad_id) {
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
          approvedAt
        }
      }
    """
  end

  let :create_squad_request_query, do: %{query: create(), variables: %{squad_id: squad().id}}

  let :squad, do: insert(:squad)
  let :user, do: insert(:user)

  def delete_squad_request_query(squad_id) do
    %{query: delete(), variables: %{id: squad_id}}
  end

  def approve_squad_request_query(squad_id) do
    %{query: approve(), variables: %{id: squad_id}}
  end

  def entities_count(struct) do
    struct |> Repo.all |> Enum.count
  end

  describe "mutations" do
    context "create_squad_request" do
      it "creates a new squad_request with valid attributes" do
        previous_count = entities_count(SquadRequest)
        api_request(create_squad_request_query())
        expect entities_count(SquadRequest) |> to(eq previous_count + 1)
      end

      context "when user has another request" do
        it "should delete old request and create new one" do
          count = entities_count(SquadRequest)
          user() |> api_request(create_squad_request_query())
          expect entities_count(SquadRequest) |> to(eq count + 1)

          count = entities_count(SquadRequest)
          user() |> api_request(create_squad_request_query())
          expect entities_count(SquadRequest) |> to(eq count)
        end
      end
    end

    context "delete_squad_request" do
      let :squad_request, do: insert(:squad_request, user: user())

      before do: squad_request()

      it "deletes existing squad_request" do
        previous_count = entities_count(SquadRequest)
        user() |> api_request(delete_squad_request_query(squad_request().id))
        expect entities_count(SquadRequest) |> to(eq previous_count - 1)
      end
    end

    context "approve_squad_request" do
      let :squad_request, do: insert(:squad_request, user: insert(:user), squad: squad())
      let :squad, do: build(:squad) |> with_commander(user()) |> insert

      before do: squad_request()

      it "approve existing squad_request and sets approved_at and approver" do
        expect squad_request().approver |> to(eq nil)
        expect squad_request().approved_at |> to(eq nil)

        user() |> api_request(approve_squad_request_query(squad_request().id))

        request = Repo.get(SquadRequest, squad_request().id) |> Repo.preload(:approver)
        %{squad_member: approver} = user() |> Repo.preload(:squad_member)

        expect request.approver |> to(eq approver)
        expect request.approver |> to_not(eq nil)
      end
    end
  end
end
