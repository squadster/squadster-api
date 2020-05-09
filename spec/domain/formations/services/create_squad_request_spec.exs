defmodule Squadster.Domain.Services.CreateSquadRequestSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Formations.SquadRequest
  alias Squadster.Formations.Services.CreateSquadRequest

  let :user, do: insert(:user)

  describe "call/2" do
    let :squad, do: insert(:squad)

    it "creates a new squad_request" do
      previous_count = entities_count(SquadRequest)
      CreateSquadRequest.call(squad().id, user())
      expect entities_count(SquadRequest) |> to(eq previous_count + 1)
    end

    context "when user has another request" do
      it "should delete old request and create new one" do
        count = entities_count(SquadRequest)
        {:ok, %{id: id}} = CreateSquadRequest.call(squad().id, user())

        expect entities_count(SquadRequest) |> to(eq count + 1)

        count = entities_count(SquadRequest)
        {:ok, %{id: new_id}} = CreateSquadRequest.call(squad().id, user())

        expect entities_count(SquadRequest) |> to(eq count)
        expect new_id |> to_not(eq id)
      end
    end

    context "when user has a squad" do
      before do
        insert(:squad_member, user: user(), squad: squad())
      end

      it "should not create request" do
        initial_count = entities_count(SquadRequest)

        CreateSquadRequest.call(squad().id, user())

        expect entities_count(SquadRequest) |> to(eq initial_count)
      end

      it "should return error with message" do
        {:error, message} = CreateSquadRequest.call(squad().id, user())
        expect message |> to_not(be_nil())
      end
    end
  end
end
