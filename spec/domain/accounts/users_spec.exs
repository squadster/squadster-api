defmodule Squadster.Domain.Accounts.UsersSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

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
        %{valid?: is_valid} = %{uid: "123", first_name: "John", last_name: "Galt"} |> User.auth_changeset
        expect is_valid |> to(be true)
      end

      defmodule SimpleUserParam do
        use ESpec, shared: true

        let_overridable [:param, :default_value, :new_value]

        context "when the param is already present on user" do
          let! :user, do: insert(:user, "#{param()}": default_value())

          it "should be execluded from changeset" do
            changeset = user() |> User.auth_changeset(%{"#{param()}": new_value()})
            expect changeset.changes[param()] |> to(eq nil)
          end
        end

        context "when the param is not present on user" do
          let! :user, do: insert(:user, "#{param()}": nil)

          it "should not be execluded from changeset" do
            changeset = user() |> User.auth_changeset(%{"#{param()}": new_value()})
            expect changeset.changes[param()] |> to(eq new_value())
          end
        end
      end

      defmodule VkPriorityUserParam do
        use ESpec, shared: true

        let_overridable [:param, :default_value, :new_value]

        context "when the param is already present on user" do
          let! :user, do: insert(:user, "#{param()}": default_value())

          it "should not be execluded from changeset" do
            changeset = user() |> User.auth_changeset(%{"#{param()}": new_value()})
            expect changeset.changes[param()] |> to(eq new_value())
          end
        end

        context "when the param is not present on user" do
          let! :user, do: insert(:user, "#{param()}": nil)

          it "should not be execluded from changeset" do
            changeset = user() |> User.auth_changeset(%{"#{param()}": new_value()})
            expect changeset.changes[param()] |> to(eq new_value())
          end
        end
      end

      it_behaves_like SimpleUserParam, param: :first_name, default_value: "John", new_value: "Jack"
      it_behaves_like SimpleUserParam, param: :last_name, default_value: "Galt", new_value: "Sins"
      it_behaves_like SimpleUserParam, param: :birth_date, default_value: ~D[2002-04-21], new_value: ~D[2000-04-21]
      it_behaves_like SimpleUserParam, param: :mobile_phone, default_value: "+375111111111", new_value: "+375222222222"
      it_behaves_like SimpleUserParam, param: :university, default_value: "BSUIR", new_value: "BSU"
      it_behaves_like SimpleUserParam, param: :faculty, default_value: "faculty of pizza", new_value: "faculty of AI"
      it_behaves_like SimpleUserParam, param: :uid, default_value: "asd123", new_value: "qwe321"

      it_behaves_like VkPriorityUserParam, param: :auth_token, default_value: "V2YLKL/Hi", new_value: "ZTMm9T0XSy"
      it_behaves_like(
        VkPriorityUserParam,
        param: :vk_url,
        default_value: "https://vk.com/id500663175",
        new_value: "https://vk.com/id314474672"
      )

      it_behaves_like(
        VkPriorityUserParam,
        param: :image_url,
        default_value: "http://robohash.org/set_set1/bgset_bg2/3MWcVowjAz0RQj",
        new_value: "http://robohash.org/set_set2/bgset_bg2/aOIEj"
      )

      it_behaves_like(
        VkPriorityUserParam,
        param: :small_image_url,
        default_value: "http://robohash.org/set_set1/bgset_bg2/3MWcVowjAz0RQj",
        new_value: "http://robohash.org/set_set2/bgset_bg2/aOIEj"
      )

    end

    context "when params are invalid" do
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

        expect(data.first_name) |> to_not(be_nil())
        expect(data.last_name) |> to_not(be_nil())
        expect(data.birth_date) |> to_not(be_nil())
        expect(data.mobile_phone) |> to_not(be_nil())
        expect(data.university) |> to_not(be_nil())
        expect(data.faculty) |> to_not(be_nil())
        expect(data.small_image_url) |> to_not(be_nil())
        expect(data.image_url) |> to_not(be_nil())
        expect(data.uid) |> to_not(be_nil())
        expect(data.vk_url) |> to_not(be_nil())
        expect(data.auth_token) |> to_not(be_nil())
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
