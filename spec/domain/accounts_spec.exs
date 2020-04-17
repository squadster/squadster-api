defmodule Squadster.Domain.AccountsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model
  use Phoenix.ConnTest

  alias Squadster.Accounts
  alias Squadster.Accounts.User

  let :user, do: insert(:user)

  describe "list_users/0" do
    it "returns list of users" do
      users_count = entities_count(User)
      expect Accounts.list_users()
      |> Enum.count
      |> to(eq users_count)
    end
  end

  describe "find_user/1" do
    it "finds user by id" do
      expect user().id
      |> Accounts.find_user()
      |> to(eq user())
    end
  end

  describe "find_user_by_token/1" do
    it "finds user by token" do
      expect user().auth_token
      |> Accounts.find_user_by_token()
      |> to(eq user())
    end
  end

  describe "find_or_create_user/1" do
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
              other_params: %{"user_id" => String.to_integer(user().uid)},
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
              "id" => String.to_integer(user().uid),
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

    context "when user with given uid present" do
      it "finds user by uid and updates it" do
        {:ok, user} = auth() |> Accounts.find_or_create_user()

        expect user.id |> to(eq user().id)
        expect user.auth_token |> to(eq "token")
      end
    end

    context "when user with given uid does not present" do
      let :new_auth do
        %Ueberauth.Auth{
          auth() | extra: %{
            auth().extra | raw_info: %{
              auth().extra.raw_info | user: %{
                auth().extra.raw_info.user | "id" => 123
              }
            }
          }
        }
      end

      it "creates user" do
        {:ok, user} = new_auth() |> Accounts.find_or_create_user()
        expect user.id |> to_not(eq user().id)
      end
    end
  end

  describe "current_user/1" do
    it "returns current_user from conn" do
      conn = build_conn() |> assign(:current_user, user())

      expect conn
      |> Accounts.current_user
      |> to(eq user())
    end
  end

  describe "signed_in?/1" do
    context "when conn contains current_user" do
      it "returns true" do
        conn = build_conn() |> assign(:current_user, user())

        expect conn
        |> Accounts.signed_in?
        |> to(be true)
      end
    end

    context "when conn does not contains current_user" do
      it "returns false" do
        expect build_conn()
        |> Accounts.signed_in?
        |> to(be false)
      end
    end
  end

  describe "logout/1" do
    it "sets current_user's auth_token to nil" do
      {:ok, %{auth_token: token}} =
        build_conn()
        |> assign(:current_user, user())
        |> Accounts.logout

      expect token |> to(be nil)
    end
  end
end
