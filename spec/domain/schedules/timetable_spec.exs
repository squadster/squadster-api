defmodule Squadster.Domain.Schedules.TimetableSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Schedules.Timetable

  describe "changeset" do
    let :date, do: Faker.Date.forward(7)

    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{date: date(), squad_id: Enum.random(1..10)} |> Timetable.changeset
        expect is_valid |> to(be_true())
      end
    end

    context "when params are invalid" do
      it "is invalid" do
        %{valid?: is_valid} = %{date: date()} |> Timetable.changeset
        expect is_valid |> to(be_false())
      end
    end
  end
end
