defmodule Squadster.Domain.Services.Auth.CreateUserSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Accounts.Services.Auth.CreateUser
  alias Squadster.Accounts.User

  let auth_args: build(:ueberauth)

  describe "#call/1" do
    it "creates user" do
      initial_count = entities_count(User)

      {:created, _user} = CreateUser.call(auth_args())

      expect(entities_count(User)) |> to(eq initial_count + 1)
    end

    it "creates user_settings for user" do
      {:created, user} = CreateUser.call(auth_args())
      %{settings: settings} = user |> Repo.preload(:settings)
      expect(settings) |> to_not(eq nil)
    end
  end
end
