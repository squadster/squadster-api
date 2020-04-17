defmodule Squadster.Domain.SquadsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Formations.Squad

  let :user, do: insert(:user)
  let! :squad, do: build(:squad) |> with_commander(user()) |> insert

  describe "commander/1" do
    it "returns commander for given squad" do
      %{squad_member: commander} = user() |> Repo.preload(:squad_member)
      expect squad()
      |> Squad.commander()
      |> to(eq commander)
    end
  end
end
