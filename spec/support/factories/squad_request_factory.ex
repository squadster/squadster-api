defmodule Squadster.SquadRequestFactory do
  defmacro __using__(opts) do
    quote do
      # TODO: implement methods for associations
      def squad_request_factory do
        %Squadster.Formations.SquadRequest{
          approved_at: Faker.DateTime.backward(10),
          user: build(:user),
          squad: build(:squad),
          approver: build(:squad_member)
        }
      end
    end
  end
end