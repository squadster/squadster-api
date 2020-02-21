defmodule SquadsterWeb.Schema.SharedTypes do
  use Absinthe.Schema.Notation

  alias Squadster.Helpers.Dates

  scalar :date do
    parse &Dates.date_from_string/1
    serialize &Dates.date_to_string/1
  end

  scalar :datetime do
    parse &Dates.datetime_from_string/1
    serialize &Dates.date_to_string/1
  end
end
