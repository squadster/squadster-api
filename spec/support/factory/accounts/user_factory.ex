defmodule Squadster.Support.Factory.Accounts.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        # should be string, cannot start with zero
        uid = Enum.random(100_000_000..999_999_999) |> Integer.to_string
        avatar = Faker.Avatar.image_url

        %Squadster.Accounts.User{
          first_name: Faker.Name.first_name,
          last_name: Faker.Name.last_name,
          birth_date: Faker.Date.date_of_birth(17..20),
          mobile_phone: "+375" <> uid,
          university: "University of " <> Faker.Industry.sector,
          faculty: "Faculty of " <> Faker.Industry.sub_sector,
          uid: uid,
          auth_token: Faker.String.base64(85),
          small_image_url: avatar,
          image_url: avatar,
          vk_url: "https://vk.com/id" <> uid,
        }
      end

      def with_squad_request(user) do
        squad_request = insert(:squad_request, user: user)
        %{user | squad_request: squad_request}
      end

      def with_squad_member(user) do
        squad_member = insert(:squad_member, user: user)
        %{user | squad_member: squad_member}
      end
    end
  end
end
