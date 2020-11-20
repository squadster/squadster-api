defmodule SquadsterWeb.Schema.SchedulesTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Squadster.Formations

  object :timetable do
    field :id, non_null(:id)
    field :lessons, list_of(:lesson), resolve: dataloader(Squadster.Schedules)
    field :squad, :squad, resolve: dataloader(Squadster.Formations)
    field :date, :datetime
  end

  object :lesson do
    field :id, non_null(:id)
    field :name, :string
    field :teacher, :string
    field :index, :integer
    field :note, :string
    field :type, :string
    field :classroom, :string
    field :timetable, :timetable, resolve: dataloader(Squadster.Schedules)
  end
end
