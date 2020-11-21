defmodule Squadster.Domain.Formations.Services.UpdateSquadSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Formations.Squad
  alias Squadster.Formations.Services.UpdateSquad
  alias Squadster.Formations.Services.NotifySquadChanges

  describe "call/2" do
    let :squad_number, do: "111222"
    let :args, do: %{squad_number: squad_number()}
    let :squad, do: insert(:squad)
    let :user, do: insert(:user)

    before do
      mock NotifySquadChanges, :call
    end

    it "updates the squad" do
      {:ok, squad} = UpdateSquad.call(squad(), args(), user())
      expect squad.squad_number |> to(eq squad_number())
    end

    it "sends notifications to students" do
      {:ok, _squad} = UpdateSquad.call(squad(), args(), user())
      assert_called NotifySquadChanges, :call
    end

    context "when class_day was changed" do
      let :squad, do: insert(:squad, class_day: :wednesday)
      let :args, do: %{class_day: :friday}

      before do
        for _ <- (1..3) do
          build(:timetable) |> with_squad(squad()) |> insert
        end
      end

      it "should update all associated timetables to match new class_day" do
        {:ok, squad} = UpdateSquad.call(squad(), args(), user())
        %{timetables: timetables} = squad |> Repo.preload(:timetables)
        timetables
        |> Enum.each(fn timetable ->
          expect(timetable.date |> Date.day_of_week) |> to(eq Squad.class_day_number(squad.class_day))
        end)
      end
    end
  end
end
