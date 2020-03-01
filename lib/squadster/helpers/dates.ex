defmodule Squadster.Helpers.Dates do
  def date_from_string(string_date) do
    string_date
    |> Timex.parse!("%-d.%-m.%Y", :strftime)
    |> NaiveDateTime.to_date
  end

  def datetime_from_string(string_datetime) do
    string_datetime |> Timex.parse!("%d.%m.%Y %H:%M", :strftime)
  end

  def date_to_string(%Date{} = date) do
    date |> Timex.format!("%d.%m.%Y", :strftime)
  end

  def date_to_string(datetime) do
    datetime |> Timex.format!("%d.%m.%Y %H:%M", :strftime)
  end

  def without_microseconds(datetime) do
    DateTime.truncate(datetime, :second)
  end

  def yesterday do
    Timex.now |> Timex.shift(days: -1)
  end

  def day_of_a_week(date) do
    {day_of_a_week, _remainder} =
      date
      |> Timex.format!("%w", :strftime)
      |> Integer.parse()
    day_of_a_week + 1 # because in datetime monday is 0, tuesday is 1, etc.
  end
end
