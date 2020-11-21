defmodule Squadster.Support.Factory.Schedules.TimetableFactory do
  alias Squadster.Formations.Squad
  defmacro __using__(_opts) do
    quote do
      def timetable_factory do
        squad = build(:squad)

        %Squadster.Schedules.Timetable{
          date: calculate_date(squad.class_day),
          squad: squad
        }
      end

      def with_squad(timetable, squad) do
        %{timetable | date: calculate_date(squad.class_day), squad: squad}
      end

      defp calculate_date(class_day) do
        date = Faker.Date.forward(Enum.random(1..100))
        Timex.shift(date, days: days_gap(class_day, date))
      end

      defp days_gap(class_day, date) when is_integer(class_day) do
        class_day - (date |> Date.day_of_week)
      end

      defp days_gap(class_day, date) when is_atom(class_day) do
        Squad.ClassDayEnum.__enum_map__[class_day] - (date |> Date.day_of_week)
      end
    end
  end
end
