defmodule Squadster.Helpers.Dates do
  @date_format ~r/^(0[1-9]|[12]\d|3[01])[.](0[1-9]|1[012])[.](19|20)\d\d$/

  def date_from_string(%Absinthe.Blueprint.Input.String{value: value}) do
    case String.match?(value, @date_format) do
      true -> {:ok, parse(value)}
      false -> :error
    end
  end

  def date_from_string(string_date) do
    parse(string_date)
  end

  def datetime_from_string(string_datetime) do
    string_datetime |> Timex.parse!("%-d.%-m.%Y %H:%M", :strftime)
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

  def tomorrow do
    Timex.now |> Timex.shift(days: 1)
  end

  def day_of_a_week(date) do
    {day_of_a_week, _remainder} =
      date
      |> Timex.format!("%w", :strftime)
      |> Integer.parse()
    if day_of_a_week == 0, do: 7, else: day_of_a_week # because Sunday is 0 for Timex
  end

  defp parse(date) do
    date
    |> Timex.parse!("%-d.%-m.%Y", :strftime)
    |> NaiveDateTime.to_date
  end
end
