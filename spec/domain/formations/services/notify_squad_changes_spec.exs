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

  describe "text/1" do
    it "returns message text for given changes" do
      text = NotifySquadChanges.text(%{})
      expect(is_binary(text)) |> to(be true)
    end

    it "adds part of the message for every new change" do
      first  = NotifySquadChanges.text(%{}) |> String.length
      second = NotifySquadChanges.text(%{squad_number: "111222"}) |> String.length
      third  = NotifySquadChanges.text(%{squad_number: "111222", class_day: :monday}) |> String.length
      fourth = NotifySquadChanges.text(%{
        squad_number: "111222",
        class_day: :monday,
        advertisment: "I'm a potato"
      }) |> String.length

      expect(fourth > third and third > second and second > first) |> to(be true)
    end
  end
end
