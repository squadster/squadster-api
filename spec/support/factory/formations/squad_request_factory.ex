defmodule Squadster.Support.Factory.Formations.SquadRequestFactory do
  defmacro __using__(_opts) do
    quote do
      def squad_request_factory do
        %Squadster.Formations.SquadRequest{
          approved_at: nil,
          user: build(:user),
          squad: build(:squad),
          approver: nil
        }
      end

      def approved(request) do
        %{request | approver: insert(:squad_member), approved_at: Faker.DateTime.backward(10)}
      end

      def approved_by(request, squad_member) do
        %{request | approver: squad_member, approved_at: Faker.DateTime.backward(10)}
      end
    end
  end
end
