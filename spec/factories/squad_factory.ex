defmodule Squadster.SquadFactory do
  defmacro __using__(opts) do
    quote do
      # WARN: it fall to recursion, when build an array of associations
      def squad_factory do
        %Squadster.Formations.Squad{
          squad_number: "squad #{Faker.random_between(1, 1000)}",
          advertisment: Faker.Lorem.Shakespeare.as_you_like_it(),
          class_day: Faker.random_between(1, 7),
          # members: [build(:squad_member)],
          # requests: [build(:squad_request)]
        }
      end

      def with_commander(squad, user) do
        squad_member = insert(:squad_member, squad: squad, user: user)
        %{squad | members: [squad_member]}
      end
    end
  end
end
