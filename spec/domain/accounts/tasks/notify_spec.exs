# This test using hard-coded matches with explisit ids,
# each spec has its own let(:user) with unique id,
# this is done to not violate PK constraint in parallel
# testing, but this is not the best solution.
# TODO:
# Mockery allows dynamic matches with macros, so this
# test should be reworked to use macros for id matches.
#
defmodule Squadster.Accounts.Tasks.NotifySpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  import Mockery
  import Mockery.Assertions

  alias Squadster.Accounts.Tasks.Notify

  let :squad, do: insert(:squad)

  describe "notify/1" do
    let :message, do: "Who is John Galt?"

    before do
      mock HTTPoison, :post
    end

    context "when the target is user" do
      let :user, do: insert(:user, id: 1)

      it "sends message to this user" do
        Notify.notify(message: message(), target: user())
        assert_called HTTPoison, :post, [
          _endpoint,
          """
            {
              "text": "Who is John Galt?",
              "target": 1
            }
          """,
          _headers
        ]
      end
    end

    context "when the target is a squad" do
      let :user, do: insert(:user)
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
          let :user, do: insert(:user, id: 2)

          it "does not send message to squad commander" do
            Notify.notify(message: message(), target: squad(), options: [skip_commander: true])

            assert_called HTTPoison, :post, [_endpoint, _body, _headers], 5
            refute_called HTTPoison, :post, [
              _endpoint,
              """
                {
                  "text": "Who is John Galt?",
                  "target": 2
                }
              """,
              _headers
            ]
          end
        end

        context "when skip_deputy set to true" do
          before do
            deputy_user = insert(:user, id: 3)
            insert(:squad_member, role: :deputy_commander, squad: squad(), user: deputy_user)
          end

          it "does not send message to deputies" do
            Notify.notify(message: message(), target: squad(), options: [skip_deputy: true])

            assert_called HTTPoison, :post, [_endpoint, _body, _headers], 6
            refute_called HTTPoison, :post, [
              _endpoint,
              """
                {
                  "text": "Who is John Galt?",
                  "target": 3
                }
              """,
              _headers
            ]
          end
        end

        context "when skip_journalist set to true" do
          before do
            journalist_user = insert(:user, id: 4)
            insert(:squad_member, role: :journalist, squad: squad(), user: journalist_user)
          end

          it "does not send message to journalists" do
            Notify.notify(message: message(), target: squad(), options: [skip_journalist: true])

            assert_called HTTPoison, :post, [_endpoint, _body, _headers], 6
            refute_called HTTPoison, :post, [
              _endpoint,
              """
                {
                  "text": "Who is John Galt?",
                  "target": 4
                }
              """,
              _headers
            ]
          end
        end

        context "when there is a user id in the skip list" do
          let :user, do: insert(:user, id: 5)

          it "does not send message to this user" do
            Notify.notify(message: message(), target: squad(), options: [skip: [user().id]])

            assert_called HTTPoison, :post, [_endpoint, _body, _headers], 5
            refute_called HTTPoison, :post, [
              _endpoint,
              """
                {
                  "text": "Who is John Galt?",
                  "target": 5
                }
              """,
              _headers
            ]
          end
        end
      end
    end
  end
end

