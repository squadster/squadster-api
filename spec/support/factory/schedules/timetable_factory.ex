defmodule Squadster.Support.Factory.Schedules.TimetableFactory do
  defmacro __using__(_opts) do
    quote do
      def timetable_factory do
        %Squadster.Schedules.Timetable{
          date: Faker.Date.backward(5)
        }
      end
    end
  end
end
