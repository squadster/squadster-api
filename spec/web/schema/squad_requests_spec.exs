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

  let :create_squad_request_query, do: %{query: create(), variables: %{squad_id: squad().id}}

  let :squad, do: insert(:squad)
  let :user, do: insert(:user)

  def delete_squad_request_query(squad_id) do
    %{query: delete(), variables: %{id: squad_id}}
  end

  def api_request(payload) do
    login_as(user()) |> query(payload)
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
          api_request(create_squad_request_query())
          expect entities_count(SquadRequest) |> to(eq count + 1)

          count = entities_count(SquadRequest)
          api_request(create_squad_request_query())
          expect entities_count(SquadRequest) |> to(eq count)
        end
      end
    end

    context "delete_squad_request" do
      let :squad_request, do: insert(:squad_request, user: user())

      before do: squad_request()

      it "deletes existing squad_request" do
        previous_count = entities_count(SquadRequest)
        api_request(delete_squad_request_query(squad_request().id))
        expect entities_count(SquadRequest) |> to(eq previous_count - 1)
      end

      context "when it is not the request owner" do
        let :another_user, do: insert(:user)

        it "cannot delete the squad_request" do
          previous_count = entities_count(SquadRequest)
          login_as(another_user()) |> query(delete_squad_request_query(squad_request().id))
          expect entities_count(SquadRequest) |> to(eq previous_count)
        end

        context "but it's commander of the requested squad" do
          let :another_user, do: insert(:user)
          let :squad, do: build(:squad) |> with_commander(another_user()) |> insert
          let :squad_request, do: insert(:squad_request, user: user(), squad: squad())

          it "can delete the squad_request" do
            previous_count = entities_count(SquadRequest)
            login_as(another_user()) |> query(delete_squad_request_query(squad_request().id))
            expect entities_count(SquadRequest) |> to(eq previous_count - 1)
          end
        end
      end
    end
































    #context "approve_squad_request" do
      #let :squad_request, do: insert(:squad_request, user: user())

      #before do: squad_request()

      #it "approves existing squad_request" do
        #previous_count = entities_count(SquadRequest)
        #api_request(delete_squad_request_query(squad_request().id))
        #expect entities_count(SquadRequest) |> to(eq previous_count - 1)
      #end

      #context "when it is not the request owner" do
        #let :another_user, do: insert(:user)

        #it "cannot approve the squad_request" do
          #previous_count = entities_count(SquadRequest)
          #login_as(another_user()) |> query(delete_squad_request_query(squad_request().id))
          #expect entities_count(SquadRequest) |> to(eq previous_count)
        #end

        #context "but it's commander of the requested squad" do
          #let :another_user, do: insert(:user)
          #let :squad, do: build(:squad) |> with_commander(another_user()) |> insert
          #let :squad_request, do: insert(:squad_request, user: user(), squad: squad())

          #it "can approve squad_request" do
            #previous_count = entities_count(SquadRequest)
            #login_as(another_user()) |> query(delete_squad_request_query(squad_request().id))
            #expect entities_count(SquadRequest) |> to(eq previous_count - 1)
          #end
        #end
      #end
    #end



  end
end
