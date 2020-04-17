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

  describe "auth_changeset" do
    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{uid: "123", first_name: "John", last_name: "Galt"} |> User.changeset
        expect is_valid |> to(be true)
      end
    end

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

  describe "auth functions" do
    let :auth do
      %Ueberauth.Auth{
        credentials: %Ueberauth.Auth.Credentials{
          expires: false,
          expires_at: 1111111111,
          other: %{},
          refresh_token: nil,
          scopes: [""],
          secret: nil,
          token: "token",
          token_type: nil
        },
        extra: %Ueberauth.Auth.Extra{
          raw_info: %{
            token: %OAuth2.AccessToken{
              access_token: "token",
              expires_at: 1111111111,
              other_params: %{"user_id" => 222222222},
              refresh_token: nil,
              token_type: "Bearer"
            },
            user: %{
              "bdate" => "23.5.2000",
              "domain" => "nickname",
              "faculty" => 15785,
              "faculty_name" => "Faculty of mems",
              "first_name" => "John",
              "graduation" => 0,
              "id" => 222222222,
              "last_name" => "Galt",
              "photo_100" => Faker.Avatar.image_url,
              "photo_400" => Faker.Avatar.image_url,
              "universities" => [
                %{
                  "chair" => 2033190,
                  "chair_name" => "Intellegent memes",
                  "city" => 282,
                  "country" => 3,
                  "faculty" => 15785,
                  "faculty_name" => "Faculty of mems",
                  "id" => 94448,
                  "name" => "MEME university"
                }
              ],
              "university" => 94448,
              "university_name" => "БГУИР (бывш. МРТИ)"
            }
          }
        },
        info: %Ueberauth.Auth.Info{
          birthday: nil,
          description: nil,
          email: nil,
          first_name: "John",
          image: Faker.Avatar.image_url,
          last_name: "Galt",
          location: nil,
          name: "John Galt",
          nickname: nil,
          phone: "+375331234567",
          urls: %{vk: "https://vk.com/id"}
        },
        provider: :vk,
        strategy: Ueberauth.Strategy.VK,
        uid: nil
      }
    end

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
