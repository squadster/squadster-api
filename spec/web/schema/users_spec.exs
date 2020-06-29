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

  let :list_users do
    """
      query getUsers {
        users {
          id
        }
      }
    """
  end

  let :get_user_by_id do
    """
      query getUser($id: Int) {
        user(id: $id) {
          id
        }
      }
    """
  end

  let :get_current_user do
    """
      query getCurrentUser {
        currentUser {
          id
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
  let :users, do: %{query: list_users()}
  let :user_query, do: %{query: get_user_by_id(), variables: %{id: user().id}}
  let :current_user, do: %{query: get_current_user()}

  let :user, do: insert(:user)

  describe "queries" do
    describe "users" do
      let! :user, do: insert(:user)

      it "returns a list of users" do
        users_count = entities_count(User)
        %{"data" => %{"users" => users_list}} = user()
        |> api_request(users())
        |> json_response(200)

        expect users_list
        |> Enum.count
        |> to(eq users_count)
      end
    end

    describe "user" do
      it "returns a user by id" do
        %{"data" => %{"user" => found_user}} = user()
        |> api_request(user_query())
        |> json_response(200)

        expect found_user["id"]
        |> String.to_integer
        |> to(eq user().id)
      end
    end

    describe "current_user" do
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
    describe "update_user" do
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
