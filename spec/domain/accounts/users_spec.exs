defmodule Squadster.Domain.Accounts.UsersSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Accounts.User

  describe "changeset" do
    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{first_name: "John", last_name: "Galt"} |> User.changeset
        expect is_valid |> to(be true)
      end
    end

    context "when params are invalid" do
      context "when first_name is not set" do
        it "is not valid" do
          %{valid?: is_valid} = %{last_name: "Galt"} |> User.changeset
          expect is_valid |> to(be false)
        end
      end

      context "when last_name is not set" do
        it "is not valid" do
          %{valid?: is_valid} = %{first_name: "John"} |> User.changeset
          expect is_valid |> to(be false)
        end
      end

      context "when mobile_phone contains illegal symbols" do
        it "is not valid" do
          %{valid?: is_valid} = %{first_name: "John", last_name: "Galt", mobile_phone: "&123"} |> User.changeset
          expect is_valid |> to(be false)
        end
      end
    end
  end

  describe "auth_changeset" do
    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{uid: "123", first_name: "John", last_name: "Galt"} |> User.changeset
        expect is_valid |> to(be true)
      end
    end

    context "when params are invalid" do
      context "when first_name is not set" do
        it "is not valid" do
          %{valid?: is_valid} = %{uid: "123", last_name: "Galt"} |> User.auth_changeset
          expect is_valid |> to(be false)
        end
      end

      context "when last_name is not set" do
        it "is not valid" do
          %{valid?: is_valid} = %{uid: "123", first_name: "John"} |> User.auth_changeset
          expect is_valid |> to(be false)
        end
      end

      context "when uid is not set" do
        it "is not valid" do
          %{valid?: is_valid} = %{first_name: "John", last_name: "Galt"} |> User.auth_changeset
          expect is_valid |> to(be false)
        end
      end
    end
  end

  describe "auth functions" do
    let :auth, do: build(:ueberauth)

    describe "data_from_auth/1" do
      it "returns map with data" do
        data = User.data_from_auth(auth())

        expect(data.first_name).to_not(be_nil())
        expect(data.last_name).to_not(be_nil())
        expect(data.birth_date).to_not(be_nil())
        expect(data.mobile_phone).to_not(be_nil())
        expect(data.university).to_not(be_nil())
        expect(data.faculty).to_not(be_nil())
        expect(data.small_image_url).to_not(be_nil())
        expect(data.image_url).to_not(be_nil())
        expect(data.uid).to_not(be_nil())
        expect(data.vk_url).to_not(be_nil())
        expect(data.auth_token).to_not(be_nil())
      end
    end

    describe "uid_from_auth/1" do
      it "returns stringified uid" do
        uid = User.uid_from_auth(auth())
        expect uid |> to_not(be_nil())
        expect is_binary(uid) |> to(be true)
      end
    end
  end
end
