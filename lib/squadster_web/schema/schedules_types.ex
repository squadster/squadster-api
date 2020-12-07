defmodule SquadsterWeb.Schema.SchedulesTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias SquadsterWeb.Resolvers.Schedules, as: SchedulesResolver

  object :timetable do
    field :id, non_null(:id)
    field :lessons, list_of(:lesson), resolve: dataloader(Squadster.Schedules)
    field :squad, :squad, resolve: dataloader(Squadster.Formations)
    field :date, :date
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

  object :schedules_mutations do
    @desc "Create a timetable"
    field :create_timetable, type: :timetable do
      arg :date, type: :date
      arg :squad_id, non_null(:id)

      resolve &SchedulesResolver.create_timetable/3
    end

    # TODO: do we need it?
    @desc "Delete timetable"
    field :delete_timetable, type: :timetable do
      arg :timetable_id, non_null(:id)

      resolve &SchedulesResolver.delete_timetable/3
    end

    # TODO: do we need it?
    @desc "Update existing timetable"
    field :update_timetable, type: :timetable do
      arg :timetable_id, non_null(:id)
      arg :date, type: :date

      resolve &SchedulesResolver.update_timetable/3
    end

    @desc "Create a lesson"
    field :create_lesson, type: :lesson do
      arg :timetable_id, non_null(:id)
      arg :name, :string
      arg :teacher, :string
      arg :index, :integer
      arg :note, :string
      arg :classroom, :string
      arg :type, :string

      resolve &SchedulesResolver.create_lesson/3
    end

    @desc "Delete a lesson"
    field :delete_lesson, type: :lesson do
      arg :id, non_null(:id)

      resolve &SchedulesResolver.delete_lesson/3
    end

    @desc "Update a batch of lessons"
    field :update_lessons, type: list_of(:lesson) do
      arg :batch, list_of(:lessons_batch)

      resolve &SchedulesResolver.update_lessons/3
    end

    @desc "Update a lesson"
    field :update_lesson, type: :lesson do
      arg :id, non_null(:id)
      arg :name, :string
      arg :teacher, :string
      arg :note, :string
      arg :classroom, :string
      arg :type, :string

      resolve &SchedulesResolver.update_lesson/3
    end
  end

  input_object :lessons_batch do
    field :id, non_null(:id)
    field :index, :integer
  end
end
