# Ueberauth response mock for vk provider
# insert/1 cannot be used with this factory as it's not in a database
#
defmodule Squadster.Support.Factory.Accounts.UeberauthFactory do
  defmacro __using__(_opts) do
    quote do
      import Squadster.Helpers.Dates, only: [date_to_string: 1]

      def ueberauth_factory do
        # should be integer, cannot start with zero
        uid = Enum.random(100_000_000..999_999_999)
        token = Faker.String.base64(85)
        expires_at = Enum.random(100_000_000_0..999_999_999_9)

        first_name = Faker.Name.first_name
        last_name = Faker.Name.last_name
        avatar = Faker.Avatar.image_url

        faculty_id = Enum.random(1..100_000)
        faculty = "Faculty of " <> Faker.Industry.sub_sector
        university_id = Enum.random(1..100_000)
        university = "University of " <> Faker.Industry.sector

        %Ueberauth.Auth{
          credentials: %Ueberauth.Auth.Credentials{
            expires: false,
            expires_at: expires_at,
            other: %{},
            refresh_token: nil,
            scopes: [""],
            secret: nil,
            token: token,
            token_type: nil
          },
          extra: %Ueberauth.Auth.Extra{
            raw_info: %{
              token: %OAuth2.AccessToken{
                access_token: token,
                expires_at: expires_at,
                other_params: %{"user_id" => uid},
                refresh_token: nil,
                token_type: "Bearer"
              },
              user: %{
                "bdate" => Faker.Date.date_of_birth(17..20) |> date_to_string,
                "domain" => Faker.Internet.domain_word,
                "faculty" => faculty_id,
                "faculty_name" => faculty,
                "first_name" => first_name,
                "graduation" => 0,
                "id" => uid,
                "last_name" => last_name,
                "photo_100" => avatar,
                "photo_400" => avatar,
                "universities" => [
                  %{
                    "chair" => Enum.random(1..100_000_00),
                    "chair_name" => "Chair of " <> Faker.Industry.sub_sector,
                    "city" => Enum.random(1..10_000),
                    "country" => Enum.random(1..200),
                    "faculty" => faculty_id,
                    "faculty_name" => faculty,
                    "id" => university_id,
                    "name" => university
                  }
                ],
                "university" => university_id,
                "university_name" => university
              }
            }
          },
          info: %Ueberauth.Auth.Info{
            birthday: nil,
            description: nil,
            email: nil,
            first_name: first_name,
            image: avatar,
            last_name: last_name,
            location: nil,
            name: first_name <> last_name,
            nickname: nil,
            phone: "+375" <> Integer.to_string(uid),
            urls: %{vk: "https://vk.com/id"}
          },
          provider: :vk,
          strategy: Ueberauth.Strategy.VK,
          uid: nil
        }
      end

      def with_uid(auth, uid) do
        uid = if is_binary(uid), do: String.to_integer(uid), else: uid

        %Ueberauth.Auth{
          auth | extra: %{
            auth.extra | raw_info: %{
              auth.extra.raw_info | user: %{
                auth.extra.raw_info.user | "id" => uid
              }
            }
          }
        }
      end
    end
  end
end
