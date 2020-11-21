defmodule Squadster.Workers.NotifyDutiesSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :worker

  import Mockery
  import Mockery.Assertions

  alias Squadster.Workers.NotifyDuties
  alias Squadster.Helpers.Dates
  alias Squadster.Accounts.Tasks.Notify

  context "when there is squad with class_day tomorrow" do
    let! :squad, do: insert(:squad, class_day: Dates.tomorrow |> Date.day_of_week)

    before do
      insert(:squad_member, squad: squad(), queue_number: 1)
      mock Notify, :start_link
    end

    it "sends notification" do
      NotifyDuties.run
      assert_called Notify, :start_link
    end

    context "when there are several squads with class_day tomorrow" do
      let! :another_squad, do: insert(:squad, class_day: Dates.tomorrow |> Date.day_of_week)

      before do
        insert(:squad_member, squad: another_squad(), queue_number: 1)
      end

      it "sends notifications for each squad" do
        NotifyDuties.run
        assert_called Notify, :start_link, [_options], 2
      end
    end
  end

  context "when there is no squad with class_day tomorrow" do
    it "does not sends notification" do
      NotifyDuties.run
      refute_called Notify, :start_link
    end
  end
end
