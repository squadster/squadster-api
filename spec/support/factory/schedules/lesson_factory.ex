defmodule Squadster.Support.Factory.Schedules.LessonFactory do
  defmacro __using__(_opts) do
    quote do
      def lesson_factory do
        %Squadster.Schedules.Lesson{
          name: Faker.Lorem.word,
          teacher: Faker.Name.name,
          index: 1,
          note: Faker.Lorem.sentence,
          type: ["practical", "lecture", "lab"] |> Enum.random,
          classroom: Faker.Nato.format("#-?")
        }
      end
    end
  end
end
