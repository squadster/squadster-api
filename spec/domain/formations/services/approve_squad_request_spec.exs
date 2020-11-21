defmodule Squadster.Domain.Formations.Services.ApproveSquadRequestSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Accounts.Tasks.Notify
  alias Squadster.Formations.Services.ApproveSquadRequest
  alias Squadster.Formations.Tasks.NormalizeQueue

  let :user, do: insert(:user)
  let :squad_request, do: insert(:squad_request, user: insert(:user), squad: squad())
  let :squad, do: build(:squad) |> with_commander(user()) |> insert

  describe "call/2" do
    before do
      mock NormalizeQueue, :start_link
      mock Notify, :start_link
    end

    it "approves an existing squad_request and sets approved_at and approver" do
      ApproveSquadRequest.call(squad_request(), user())

      request = squad_request() |> reload |> Repo.preload(:approver)
      %{squad_member: approver} = user() |> Repo.preload(:squad_member)

      expect request.approver |> to(eq approver)
      expect request.approved_at |> to_not(eq nil)
    end

    it "schedules queue normalization" do
      ApproveSquadRequest.call(squad_request(), user())
      assert_called NormalizeQueue, :start_link
    end

    it "notifies user" do
      ApproveSquadRequest.call(squad_request(), user())
      assert_called Notify, :start_link
    end

    it "creates a new squad_member" do
      ApproveSquadRequest.call(squad_request(), user())
      %{user: %{squad_member: squad_member}} = squad_request() |> Repo.preload(user: :squad_member)
      expect squad_member.squad_id |> to(eq squad().id)
    end
  end
end
