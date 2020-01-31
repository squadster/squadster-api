defmodule Squadster.Helpers.Dates do
  def date_from_string(string_date) do
    [day, month, year] = string_date \
    |> String.split(".")
    |> Enum.map(fn element -> String.to_integer(element) end)

    case Date.new(year, month, day) do
      {:ok, date} -> date
      {:error, _reason} -> nil
    end
  end

  def date_to_string(date) do
    [date.day, date.month, date.year]
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.pad_leading(&1, 2, "0"))
    |> Enum.join(".")
  end
end
