defmodule Squadster.Support.Factory.SquadMemberFactory do
  defmacro __using__(opts) do
    quote do
      def squad_member_factory do
        %Squadster.Formations.SquadMember{
          role: :student,
          queue_number: Faker.random_between(1, 30),
          user: build(:user),
          squad: build(:squad)
        }
      end

      def make_commander(member) do
        %{member | role: :commander}
      end

      def make_deputy_commander(member) do
        %{member | role: :deputy_commander}
      end

      def make_journalist(member) do
        %{member | role: :journalist}
      end
    end
  end
end
