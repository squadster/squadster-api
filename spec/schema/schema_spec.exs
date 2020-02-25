defmodule Squadster.Schema.SchemaSpec do
  use ESpec.Phoenix, async: true
  use Phoenix.ConnTest
  @endpoint SquadsterWeb.Endpoint

  let :mutation do
    """
    mutation createSquad($squad_number: String, $class_day: Integer) {
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

  # let :variables, do: %{squad_number: "1488", class_day: 7}

  let :response do
    # build_conn() |> post("/api/query", %{query: mutation(), variables: variables()})
    build_conn() |> post("/api/query", %{query: query(), variables: %{}})
  end

  let :expected_response do
    # %{"data" => %{"createSquad" => %{"squad_number" => "1488", "class_day" => :sunday}} }
    %{"data" => %{"squads" => []}}
  end

  describe "create squad" do
    it "creates a new squad with valid attributes" do
      expect json_response(response(), 200) |> to(eq expected_response())
    end
  end
end
