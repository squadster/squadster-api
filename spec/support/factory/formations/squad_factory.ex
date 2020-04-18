defmodule Squadster.Support.Factory.Formations.SquadFactory do
  defmacro __using__(_opts) do
    quote do
      def squad_factory do
        %Squadster.Formations.Squad{
          squad_number: "squad #{Faker.random_between(1, 1000)}",
          advertisment: Faker.Lorem.Shakespeare.as_you_like_it(),
          class_day: Faker.random_between(1, 7),
        }
      end

      def with_commander(squad, user) do
        squad_member = insert(:squad_member, squad: squad, user: user, role: :commander)
        %{squad | members: [squad_member]}
      end
    end
  end
end
