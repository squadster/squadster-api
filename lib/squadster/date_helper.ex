defmodule Squadster.DateHelper do
  def date_from_string(string_date) do
    [day, month, year] = string_date \
    |> String.split(".")
    |> Enum.map(fn element -> String.to_integer(element) end)
    case Date.new(year, month, day) do
      {:ok, date} -> date
      {:error, _reason} -> nil
    end
  end
end
