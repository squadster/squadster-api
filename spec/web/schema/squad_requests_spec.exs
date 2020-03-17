defmodule Squadster.Web.Schema.SquadRequestSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller
  use Phoenix.ConnTest

  import Squadster.Support.Factory

  alias Squadster.Formations.SquadRequest

  let :create do
    """
      mutation createSquadRequest($squad_id: Int) {
        createSquadRequest(squad_id: $squad_id) {
          squad
        }
      }
    """
  end

  let :create_squad_request_query, do: %{query: create(), variables: %{squad_id: squad().id}}

  let :squad, do: build(:squad)
  let :user, do: insert(:user)

  def api_request(payload) do
    login_as(user()) |> query(payload)
  end

  def entities_count(struct) do
    struct |> Repo.all |> Enum.count
  end

  describe "mutations" do
    it "creates a new squad_request with valid attributes" do
      previous_count = entities_count(SquadRequest)
      api_request(create_squad_request_query())
      expect entities_count(SquadRequest) |> to(eq previous_count + 1)
    end
  end
end
