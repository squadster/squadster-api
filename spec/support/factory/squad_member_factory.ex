defmodule Squadster.Support.Factory.SquadMemberFactory do
  defmacro __using__(_opts) do
    quote do
      def squad_member_factory do
        %Squadster.Formations.SquadMember{
          role: :student,
          queue_number: Faker.random_between(1, 30),
          user: build(:user),
          squad: build(:squad)
        }
      end
    end
  end
end
