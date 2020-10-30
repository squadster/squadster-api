defmodule Squadster.Web.Schema.UsersSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  alias Squadster.Helpers.Dates

  let :user, do: insert(:user)

  describe "queries" do
    describe "current_user" do
      let :current_user, do: %{query: current_user_query()}
      let :current_user_query do
        """
          query getCurrentUser {
            currentUser {
              id
            }
          }
        """
      end

      it "returns a current user" do
        %{"data" => %{"currentUser" => found_user}} = user()
        |> api_request(current_user())
        |> json_response(200)

        expect found_user["id"]
        |> String.to_integer
        |> to(eq user().id)
      end
    end
  end

  describe "mutations" do
    describe "update_current_user" do
      let :update_current_user, do: %{query: update_current_user_mutation(), variables: params()}
      let :update_current_user_mutation do
        """
          mutation updateCurrentUser(
            $first_name:   String,
            $last_name:    String,
            $birth_date:   Date,
            $university:   String,
            $faculty:      String,
            $mobile_phone: String
          ) {
            updateCurrentUser(
              firstName:   $first_name,
              lastName:    $last_name,
              birthDate:   $birth_date,
              mobilePhone: $mobile_phone,
              university:  $university,
              faculty:     $faculty
            ) {
              firstName
              lastName
              birthDate
              mobilePhone
              university
              faculty
            }
          }
        """
      end

      let :params do
        %{
          first_name: Faker.Person.first_name,
          last_name: Faker.Person.last_name,
          birth_date: Dates.date_to_string(Faker.Date.date_of_birth),
          mobile_phone: "+375" <> Integer.to_string(Enum.random(100_000_000..999_999_999)),
          university: Faker.Industry.sector,
          faculty: Faker.Industry.sub_sector
        }
      end

      it "updates user's attributes" do
        user() |> api_request(update_current_user())

        user = reload(user())

        expect user.first_name |> to(eq params().first_name)
        expect user.last_name |> to(eq params().last_name)
        expect user.birth_date |> Dates.date_to_string |> to(eq params().birth_date)
        expect user.mobile_phone |> to(eq params().mobile_phone)
        expect user.university |> to(eq params().university)
        expect user.faculty |> to(eq params().faculty)
      end
    end
  end
end
