defmodule Squadster.Domain.Services.UpdateSquadMemberSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Formations.SquadRequest
  alias Squadster.Formations.Services.UpdateSquadMember

  let :user, do: insert(:user)
  let :squad_request, do: insert(:squad_request, user: insert(:user), squad: squad())
  let :squad, do: build(:squad) |> with_commander(user()) |> insert

  describe "call/2" do
  end
end
