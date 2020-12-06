# TODO: Mockery allows dynamic matches with macros, so this
# test should be improved to use macros to test cases when
# message is not set to users with specific roles
#
defmodule Squadster.Accounts.Tasks.NotifySpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Accounts.Tasks.Notify
  alias Squadster.Mailer
  alias Squadster.Accounts.UserSettings

  let :squad, do: insert(:squad)

  describe "notify/1" do
    let :message, do: "Who is John Galt?"
    let :user, do: insert(:user)

    before do
      mock HTTPoison, :post
    end

    context "when the target is user" do
      before do
        mock Mailer, :send
      end

      it "sends message to this user" do
        Notify.notify(message: message(), target: user())
        assert_called HTTPoison, :post
      end

      context "when user has email notifications enabled" do
        before do
          user()
          |> Repo.preload(:settings)
          |> Map.get(:settings)
          |> UserSettings.changeset(%{email_notifications_enabled: true})
          |> Repo.update
        end

        it "sends email message to this user" do
          Notify.notify(message: message(), target: user() |> Repo.preload(:settings, force: true))
          assert_called Mailer, :send
        end

        context "when user does not have email" do
          let :user, do: insert(:user, email: nil)

          it "does not sent email message to this user" do
            Notify.notify(message: message(), target: user())

            refute_called Mailer, :send
          end
        end
      end

      context "when user does not have email notifications enabled" do
        it "ooes not sent email message to this user" do
          Notify.notify(message: message(), target: user())

          refute_called Mailer, :send
        end
      end
    end

    context "when the target is a squad" do
      let :squad, do: build(:squad) |> with_commander(user()) |> insert

      before do
        insert_list(5, :squad_member, squad: squad())
        mock HTTPoison, :post
      end

      it "sends message to all users in squad" do
        Notify.notify(message: message(), target: squad())
        assert_called HTTPoison, :post, [_endpoint, _body, _headers], 6
      end

      describe "options" do
        context "when skip_commander set to true" do
          it "does not send message to squad commander" do
            Notify.notify(message: message(), target: squad(), options: [skip_commander: true])

            assert_called HTTPoison, :post, [_endpoint, _body, _headers], 5
          end
        end

        context "when skip_deputy set to true" do
          before do
            deputy_user = insert(:user)
            insert(:squad_member, role: :deputy_commander, squad: squad(), user: deputy_user)
          end

          it "does not send message to deputies" do
            Notify.notify(message: message(), target: squad(), options: [skip_deputy: true])

            assert_called HTTPoison, :post, [_endpoint, _body, _headers], 6
          end
        end

        context "when skip_journalist set to true" do
          before do
            journalist_user = insert(:user)
            insert(:squad_member, role: :journalist, squad: squad(), user: journalist_user)
          end

          it "does not send message to journalists" do
            Notify.notify(message: message(), target: squad(), options: [skip_journalist: true])

            assert_called HTTPoison, :post, [_endpoint, _body, _headers], 6
          end
        end

        context "when there is a user id in the skip list" do
          it "does not send message to this user" do
            Notify.notify(message: message(), target: squad(), options: [skip: [user().id]])

            assert_called HTTPoison, :post, [_endpoint, _body, _headers], 5
          end
        end
      end
    end
  end
end
