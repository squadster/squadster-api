defmodule Squadster.Domain.Services.UpdateSquadSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Formations.Squad
  alias Squadster.Formations.Services.UpdateSquad

  describe "call/2" do
    let :squad_number, do: "111222"
    let :args, do: %{squad_number: squad_number()}
    let :squad, do: insert(:squad)
    let :user, do: insert(:user)

    it "updates the squad" do
      {:ok, _squad} = UpdateSquad.call(squad(), args(), user())

      squad = Squad |> Repo.get(squad().id)

      expect squad.squad_number |> to(eq squad_number())
    end
  end
end
