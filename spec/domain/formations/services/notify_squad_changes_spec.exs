defmodule Squadster.Domain.Formations.Services.NotifySquadChangesSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Formations.Services.NotifySquadChanges
  alias Squadster.Accounts.Tasks.Notify

  let :user, do: insert(:user)
  let :squad, do: build(:squad, class_day: :friday) |> with_commander(user()) |> insert

  describe "call/3" do
    before do
      mock Notify, :start_link
    end

    it "notifies given squad members" do
      NotifySquadChanges.call(%{}, squad(), user())
      assert_called Notify, :start_link
    end
  end
end
