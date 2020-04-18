defmodule Squadster.Web.Schema.SquadSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  alias Squadster.Formations.Squad

  let :create do
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
      mutation deleteSquad($id: Int) {
        deleteSquad(id: $id) {
          squadNumber
        }
      }
    """
  end

  let :update do
    """
      mutation updateSquad($id: Int, $squad_number: String, $advertisment: String, $class_day: Int) {
        updateSquad(id: $id, squad_number: $squad_number, advertisment: $advertisment, class_day: $class_day) {
          squad_number
          advertisment
          class_day
        }
      }
    """
  end

  let :list_squads_query, do: %{query: query()}
  let :create_squad_query, do: %{query: create(), variables: create_params()}

  let :create_params, do: %{squad_number: "123456", class_day: 3}
  let :update_params, do: %{
    id: nil,
    squad_number: "1r2a3n4d5o6m",
    advertisment: "Very random string that cannot be generated by Faker, oogoo",
    class_day: 4
  }

  let :user, do: insert(:user)

  def delete_squad_query(squad_id) do
    %{query: delete(), variables: %{id: squad_id}}
  end

  def update_squad_query(squad_id) do
    params = %{update_params() | id: squad_id}
    %{query: update(), variables: params}
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
    context "create_squad" do
      it "creates a new squad with valid attributes" do
        previous_count = entities_count(Squad)

        api_request(create_squad_query())

        expect entities_count(Squad) |> to(eq previous_count + 1)
      end
    end

    context "delete_squad" do
      it "deletes a squad by id" do
        squad = build(:squad) |> with_commander(user()) |> insert
        previous_count = entities_count(Squad)

        user() |> api_request(delete_squad_query(squad.id))

        expect entities_count(Squad) |> to(eq previous_count - 1)
      end
    end

    context "update_squad" do
      it "updates a squad by id" do
        squad = build(:squad) |> with_commander(user()) |> insert

        user() |> api_request(update_squad_query(squad.id))

        expect Repo.get(Squad, squad.id).advertisment |> to(eq update_params().advertisment)
        expect {:ok, Repo.get(Squad, squad.id).class_day} |> to(eq Squad.ClassDayEnum.cast(update_params().class_day))
        expect Repo.get(Squad, squad.id).squad_number |> to(eq update_params().squad_number)
      end
    end
  end
end
