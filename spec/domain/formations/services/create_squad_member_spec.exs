defmodule Squadster.Domain.Formations.Services.CreateSquadMember do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Formations.Services.CreateSquadMember
  alias Squadster.Formations.Tasks.NormalizeQueue

  let :user, do: insert(:user)
  let :squad, do: insert(:squad)

  describe "call/2" do
    before do
      mock NormalizeQueue, :start_link
    end

    it "schedules queue normalization" do
      user() |> CreateSquadMember.call(squad())
      assert_called NormalizeQueue, :start_link
    end

    it "creates a new squad_member" do
      user() |> CreateSquadMember.call(squad())
      %{squad_member: %{squad_id: squad_id}} = user() |> Repo.preload(:squad_member)
      expect squad_id |> to(eq squad().id)
    end
  end
end
