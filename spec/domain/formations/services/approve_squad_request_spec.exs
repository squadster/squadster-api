defmodule Squadster.Domain.Services.ApproveSquadRequestSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Formations
  alias Squadster.Formations.SquadRequest

  let :user, do: insert(:user)

  describe "call/2" do
    let! :squad_request, do: insert(:squad_request, user: insert(:user), squad: squad())
    let :squad, do: build(:squad) |> with_commander(user()) |> insert

    it "approves an existing squad_request and sets approved_at and approver" do
      Formations.approve_squad_request(squad_request().id, user())

      request = SquadRequest |> Repo.get(squad_request().id) |> Repo.preload(:approver)
      %{squad_member: approver} = user() |> Repo.preload(:squad_member)

      expect request.approver |> to(eq approver)
      expect request.approved_at |> to_not(eq nil)
    end

    it "creates a new squad_member" do
      Formations.approve_squad_request(squad_request().id, user())
      %{user: %{squad_member: squad_member}} = squad_request() |> Repo.preload(user: :squad_member)
      expect squad_member.squad_id |> to(eq squad().id)
    end
  end
end
