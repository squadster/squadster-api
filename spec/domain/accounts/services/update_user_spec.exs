defmodule Squadster.Domain.Services.UpdateUserSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Accounts.User
  alias Squadster.Accounts.Services.UpdateUser

  let :user, do: insert(:user)
  let :update_params, do: %{
    first_name: Faker.Name.first_name,
    last_name: Faker.Name.last_name,
    birth_date: Faker.Date.date_of_birth,
    mobile_phone: "+375" <> Integer.to_string(Enum.random(100_000_000..999_999_999)),
    university: Faker.Industry.sector,
    faculty: Faker.Industry.sub_sector
  }

  describe "#call/1" do
    it "updates user info" do
      UpdateUser.call(user(), update_params())

      user = User |> Repo.get(user().id)

      expect user.first_name |> to(eq update_params().first_name)
      expect user.last_name |> to(eq update_params().last_name)
      expect user.birth_date |> to(eq update_params().birth_date)
      expect user.mobile_phone |> to(eq update_params().mobile_phone)
      expect user.university |> to(eq update_params().university)
      expect user.faculty |> to(eq update_params().faculty)
    end
  end
end
