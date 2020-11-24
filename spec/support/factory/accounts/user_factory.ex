defmodule Squadster.Support.Factory.Accounts.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        # should be string, cannot start with zero
        uid = Enum.random(100_000_000..999_999_999) |> Integer.to_string
        avatar = Faker.Avatar.image_url

        %Squadster.Accounts.User{
          hash_id: :crypto.strong_rand_bytes(16) |> Base.url_encode64,
          first_name: Faker.Person.first_name,
          last_name: Faker.Person.last_name,
          birth_date: Faker.Date.date_of_birth(17..20),
          mobile_phone: "+375" <> uid,
          university: "University of " <> Faker.Industry.sector,
          faculty: "Faculty of " <> Faker.Industry.sub_sector,
          uid: uid,
          auth_token: Faker.String.base64(85),
          small_image_url: avatar,
          image_url: avatar,
          vk_url: "https://vk.com/id" <> uid,
          settings: build(:user_settings)
        }
      end

      def with_squad_request(user) do
        squad_request = build(:squad_request, user: nil, user_id: user.id)
        %{user | squad_request: squad_request}
      end

      def with_request_to_squad(user, squad) do
        squad_request = build(:squad_request, user: nil, squad: nil, user_id: user.id, squad_id: squad.id)
        %{user | squad_request: squad_request}
      end

      def with_squad_member(user) do
        squad_member = build(:squad_member, user: nil, user_id: user.id)
        %{user | squad_member: squad_member}
      end
    end
  end
end
