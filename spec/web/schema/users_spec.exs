defmodule Squadster.Web.Schema.UsersSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :controller

  alias Squadster.Accounts.User
  alias Squadster.Helpers.Dates

  let :update do
    """
      mutation updateUser(
        $first_name:   String,
        $last_name:    String,
        $birth_date:   Date,
        $university:   String,
        $faculty:      String,
        $mobile_phone: String
      ) {
        updateUser(
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

  let :params, do: %{
    first_name: Faker.Name.first_name,
    last_name: Faker.Name.last_name,
    birth_date: Dates.date_to_string(Faker.Date.date_of_birth),
    mobile_phone: "+375" <> Integer.to_string(Enum.random(100_000_000..999_999_999)),
    university: Faker.Industry.sector,
    faculty: Faker.Industry.sub_sector
  }

  let :update_user, do: %{query: update(), variables: params()}

  let :user, do: insert(:user)

  describe "mutations" do
    context "update_user" do
      it "updates user's attributes" do
        user() |> api_request(update_user())

        user = User |> Repo.get(user().id)

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
