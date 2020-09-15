defmodule Squadster.Domain.Formations.Services.CreateSquadSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Formations.Squad
  alias Squadster.Formations.Services.CreateSquad

  let :user, do: insert(:user)
  let :create_params, do: %{squad_number: "123456", class_day: 3}

  describe "call/2" do
    it "creates a new squad with valid attributes" do
      previous_count = entities_count(Squad)

      CreateSquad.call(create_params(), user())

      expect entities_count(Squad) |> to(eq previous_count + 1)
    end

    it "sets creator as a commander" do
      CreateSquad.call(create_params(), user())

      %{squad_member: member} = user() |> Repo.preload(:squad_member)

      expect(Squad |> last |> Squad.commander) |> to(eq member)
    end

    context "when creator has a squad_request" do
      before do
        insert(:squad_request, user: user(), squad: insert(:squad))
      end

      it "removes the request" do
        CreateSquad.call(create_params(), user())

        %{squad_request: request} = user() |> Repo.preload(:squad_request)

        expect(request) |> to(eq nil)
      end
    end
  end
end
