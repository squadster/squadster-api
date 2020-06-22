defmodule Squadster.Domain.Helpers.DatesSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :helper

  alias Squadster.Helpers.Dates

  let :date_string, do: "21.07.2000"
  let :invalid_date_string, do: "12-123.1202"
  let :date, do: ~D[2000-07-21]
  let :absinthe_object, do: %Absinthe.Blueprint.Input.String{value: date_string()}
  let :absinthe_object_with_invalid_date, do: %Absinthe.Blueprint.Input.String{value: invalid_date_string()}


  let :datetime_string, do: "21.07.2000 12:15"
  let :datetime, do: ~U[2000-07-21 12:15:03.15Z]
  let :datetime_without_microseconds, do: ~U[2000-07-21 12:15:03Z]

  let :naive_datetime, do: ~N[2000-07-21 12:15:00]

  describe "date_from_string/1" do
    context "when Absinthe object is passed" do
      it "takes value and parses it from string with '%-d.%-m.%Y' format" do
        expect Dates.date_from_string(absinthe_object()) |> to(eq {:ok, date()})
      end

      it "returns error if string does not match '%-d.%-m.%Y' format" do
        expect Dates.date_from_string(absinthe_object_with_invalid_date()) |> to(eq :error)
      end
    end

    context "when string is passed" do
      it "parses Date from string with '%-d.%-m.%Y' format" do
        expect Dates.date_from_string(date_string()) |> to(eq date())
      end

      context "when one-digit date elements passed" do
        let :one_digit_date_string, do: "21.7.2000"

        it "parse date correctly" do
          expect Dates.date_from_string(one_digit_date_string()) |> to(eq date())
        end
      end
    end
  end

  describe "datetime_from_string/1" do
    it "parses DateTime from string with '%-d.%-m.%Y %H:%M' format and truncates microseconds" do
      expect Dates.datetime_from_string(datetime_string()) |> to(eq naive_datetime())
    end

    context "when one-digit date elements passed" do
      let :one_digit_datetime_string, do: "21.7.2000 12:15"

      it "parse date correctly" do
        expect Dates.datetime_from_string(one_digit_datetime_string()) |> to(eq naive_datetime())
      end
    end
  end

  describe "date_to_string/1" do
    context "when argument is a Date" do
      it "serializes Date to string in format '%d.%m.%Y'" do
        expect Dates.date_to_string(date()) |> to(eq date_string())
      end
    end

    context "when argument is a DateTime" do
      it "serializes DateTime to string in format '%d.%m.%Y %H:%M'" do
        expect Dates.date_to_string(datetime()) |> to(eq datetime_string())
      end
    end
  end

  describe "without_microseconds/1" do
    it "deletes microseconds from DateTime" do
      expect Dates.without_microseconds(datetime()) |> to(eq datetime_without_microseconds())
    end
  end

  describe "yesterday/0" do
    it "returns yesterday" do
      expect Dates.yesterday.day |> to(eq Timex.shift(Timex.now, days: -1).day)
    end
  end

  describe "day_of_a_week/1" do
    it "returns current day of a week" do
      expect Dates.day_of_a_week(datetime()) |> to(eq 5)
    end

    context "when it's Sunday" do
      let :sunday, do: datetime() |> Timex.shift(days: 2)

      it "returns 7 instead of 0" do
        expect Dates.day_of_a_week(sunday()) |> to(eq 7)
      end
    end
  end
end
