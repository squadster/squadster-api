defmodule Squadster.Support.Factory.SquadMemberFactory do
  defmacro __using__(opts) do
    quote do
      # TODO: implement methods for associations
      def squad_member_factory do
        %Squadster.Formations.SquadMember{
          role: :commander,
          queue_number: Faker.random_between(1, 30),
          user: build(:user),
          squad: build(:squad)
        }
      end
    end
  end
end
