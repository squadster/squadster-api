defmodule Squadster.Domain.Services.Auth.UpdateUserSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery.Assertions

  alias Squadster.Accounts.Services.Auth.UpdateUser
  alias Squadster.Accounts.User

  let user: insert(:user)
  let auth_args: build(:ueberauth)

  describe "#call/2" do
    it "updates user" do
      {:found, user} = user() |> UpdateUser.call(auth_args())

      expect(user.image_url) |> to(eq auth_args().extra.raw_info.user["photo_400"])
    end

    it "uses auth_changeset to filter params" do
      {:found, _user} = user() |> UpdateUser.call(auth_args())

      assert_called User, :auth_changeset
    end

    #it "should not update auth_token" do
      #{:found, user} = user() |> UpdateUser.call(auth_args())

      #expect(user.auth_token) |> to(eq user().auth_token)
    #end
  end
end
