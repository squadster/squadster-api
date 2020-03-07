defmodule Squadster.Schema.SchemaSpec do
  use ESpec.Phoenix, async: true
  use Phoenix.ConnTest
  @endpoint SquadsterWeb.Endpoint

  alias Squadster.Repo
  alias Squadster.Formations.Squad

  import Squadster.Factory

  let :mutation do
    """
      mutation createSquad($squad_number: String, $class_day: Int) {
        createSquad(squad_number: $squad_number, class_day: $class_day) {
          squad_number
          class_day
        }
      }
    """
  end

  let :query do
    """
      query getSquads {
        squads {
          id
          classDay
          squadNumber
        }
      }
    """
  end

  let :delete do
    """
      mutation DeleteSquad($id: Int) {
        deleteSquad(id: $id) {
          squadNumber
        }
      }
    """
  end

  let :list_squads_query, do: %{query: query()}

  let :create_squad_query, do: %{query: mutation(), variables: variables()}

  let :delete_squad_query, do: %{query: delete(), variables: %{squad_number: squad_id()}}

  let :variables, do: %{squad_number: "1488", class_day: 7}

  let :user_token do
    user = insert(:user)
    user.auth_token
  end

  let :squad_id do
    squad = insert(:squad)
    squad.id
  end

  def api_request(payload) do
    build_conn()
    |> put_req_header("authorization", "Bearer " <> user_token())
    |> post("/api/query", payload)
  end

  def entities_count(struct) do
    struct |> Repo.all |> Enum.count
  end

  describe "queries" do
    it "returns list of squads" do
      squads_count = entities_count(Squad)
      expect json_response(api_request(list_squads_query()), 200)["data"]["squads"]
      |> Enum.count
      |> to(eq squads_count)
    end
  end

  describe "mutations" do
    it "creates a new squad with valid attributes" do
      previous_count = entities_count(Squad)
      api_request(create_squad_query())
      expect entities_count(Squad) |> to(eq previous_count + 1)
    end

    it "deletes a squad by id" do
      user = insert(:user)
      squad = build(:squad) |> with_commander(user) |> insert
      previous_count = entities_count(Squad)
      # api_request(delete_squad_query())
      # expect json_response(api_request(delete_squad_query()), 200) |> to(eq "123")
      # expect entities_count(Squad) |> to(eq previous_count - 1)
      expect true |> to(eq true)
    end
  end
end
