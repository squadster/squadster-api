defmodule SquadsterWeb.SchemaTest do
  use SquadsterWeb.ConnCase

  alias Squadster.Accounts.User
  alias Squadster.Repo

  def query do
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

  test "asdd" do
    response =
      build_conn()
      |> put_req_header("authorization", "Bearer " <> Repo.get(User, 1).auth_token)
      |> post("/api/query", %{query: query})

    assert json_response(response, 200) == "123"
  end

end
