defmodule Squadster.Domain.Schedules.LessonSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Schedules.Lesson

  describe "changeset" do
    let :necessary_params do
      %{
        name: Faker.Industry.industry,
        index: Enum.random(1..6),
        timetable_id: Enum.random(1..100)
      }
    end

    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = necessary_params() |> Lesson.changeset
        expect is_valid |> to(be_true())
      end
    end

    context "when params are invalid" do
      context "when name is not set" do
        it "is invalid" do
          %{valid?: is_valid} = necessary_params() |> Map.delete(:name) |> Lesson.changeset
          expect is_valid |> to(be_false())
        end
      end

      context "when index is not set" do
        it "is invalid" do
          %{valid?: is_valid} = necessary_params() |> Map.delete(:index) |> Lesson.changeset
          expect is_valid |> to(be_false())
        end
      end

      context "when timetable_id is not set" do
        it "is invalid" do
          %{valid?: is_valid} = necessary_params() |> Map.delete(:timetable_id) |> Lesson.changeset
          expect is_valid |> to(be_false())
        end
      end
    end
  end
end
