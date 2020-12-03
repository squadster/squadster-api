defmodule Squadster.Domain.Formations.Services.NotifySquadChangesSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Formations.Services.NotifySquadChanges
  alias Squadster.Formations.Squad
  alias Squadster.Accounts.Tasks.Notify

  let :user, do: insert(:user)
  let :squad, do: build(:squad, class_day: :friday) |> with_commander(user()) |> insert

  describe "call/3" do
    before do
      mock Notify, :start_link
    end

    it "notifies given squad members" do
      Squad.changeset(%{squad_number: "123"}).changes |> NotifySquadChanges.call(squad(), user())
      assert_called Notify, :start_link
    end

    context "when changes do not include class_day, squad_number or advertisment" do
      it "should not notify user" do
        Squad.changeset(%{link_invitations_enabled: true}).changes |> NotifySquadChanges.call(squad(), user())
        refute_called Notify, :start_link
      end
    end
  end
end
