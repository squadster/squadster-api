defmodule Squadster.Workers.ShiftQueuesSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :worker

  import Mockery.Assertions

  alias Squadster.Workers.ShiftQueues
  alias Squadster.Helpers.Dates

  let :squad, do: insert(:squad, class_day: Dates.tomorrow |> Dates.day_of_a_week)
  let! :members, do: insert_list(5, :squad_member, squad: squad())

  context "when squad's class_day is yesterday" do
    let :squad, do: insert(:squad, class_day: Dates.yesterday |> Dates.day_of_a_week)

    describe "shifted member" do
      context "when member is in queue" do
        let! :member, do: insert(:squad_member, squad: squad(), queue_number: 5)

        it "should decrement queue_number" do
          ShiftQueues.run
          %{queue_number: queue_number} = member() |> reload
          expect queue_number |> to(eq member().queue_number - 1)
        end
      end

      context "when member is first in queue" do
        let! :first_member, do: insert(:squad_member, squad: squad(), queue_number: 1)

        it "should become last" do
          ShiftQueues.run
          %{queue_number: queue_number} = reload(first_member())
          %{queue_number: last_number} = members() |> Enum.max_by(&(&1.queue_number))
          expect queue_number |> to(eq last_number)
        end
      end

      context "when member has nil queue number" do
        let :member_out_of_duty, do: insert(:squad_member, squad: squad(), queue_number: nil)

        it "should not be updated" do
          ShiftQueues.run
          %{queue_number: queue_number} = member_out_of_duty() |> reload
          expect queue_number |> to(eq nil)
        end
      end
    end
  end

  context "when squad's class_day is not yesterday" do
    it "does nothing" do
      ShiftQueues.run
      refute_called Multi, :update
    end
  end
end
