defmodule Squadster.Domain.Formations.Services.DeleteSquadRequestSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Accounts.Tasks.Notify
  alias Squadster.Formations.Services.DeleteSquadRequest
  alias Squadster.Formations.SquadRequest

  let! squad_request: insert(:squad_request)
  let user: insert(:user)

  describe "call/1" do
    before do
      mock Notify, :start_link
    end

    it "deletes an existing squad_request" do
      previous_count = entities_count(SquadRequest)
      {:ok, _request} = user() |> DeleteSquadRequest.call(squad_request())
      expect entities_count(SquadRequest) |> to(eq previous_count - 1)
    end

    it "notifies user" do
      {:ok, _request} = user() |> DeleteSquadRequest.call(squad_request())
      assert_called Notify, :start_link
    end

    context "when user deletes its own request" do
      let! squad_request: insert(:squad_request, user: user())

      it "deletes an existing squad_request" do
        previous_count = entities_count(SquadRequest)
        {:ok, _request} = user() |> DeleteSquadRequest.call(squad_request())
        expect entities_count(SquadRequest) |> to(eq previous_count - 1)
      end

      it "should not notify user" do
        {:ok, _request} = user() |> DeleteSquadRequest.call(squad_request())
        refute_called Notify, :start_link
      end
    end
  end
end
