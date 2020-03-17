defmodule Squadster.Domain.Helpers.PermissionsSpec do
  use ESpec.Phoenix, async: true

  import Squadster.Support.Factory

  alias Squadster.Helpers.Permissions
  alias Squadster.Repo

  let :user do
    member = insert(:squad_member, role: :commander)
    insert(:user, squad_member: member)
  end

  let :squad do
    %{squad_member: %{squad: squad}} = user() |> Repo.preload(squad_member: :squad)
    squad
  end

  let :another_squad do
    insert(:squad)
  end

  let :request do
    insert(:squad_request, squad: squad())
  end

  let :request_to_another_squad do
    insert(:squad_request)
  end

  describe "can_update?/2" do
    context "when checking squad" do
      context "if user is a commander of the squad" do
        it "returns true" do
          expect(user() |> Permissions.can_update?(squad())) |> to(eq true)
        end

        context "and this is not a target squad" do
          it "returns false" do
            expect(user() |> Permissions.can_update?(another_squad())) |> to(eq false)
          end
        end
      end

      context "if user is a deputy_commander of the squad" do
        let :user do
          member = insert(:squad_member, role: :deputy_commander)
          insert(:user, squad_member: member)
        end

        it "returns true" do
          expect(user() |> Permissions.can_update?(squad())) |> to(eq true)
        end

        context "and this is not a target squad" do
          it "returns false" do
            expect(user() |> Permissions.can_update?(another_squad())) |> to(eq false)
          end
        end
      end

      context "if user is a journalist of the squad" do
        let :user do
          member = insert(:squad_member, role: :journalist)
          insert(:user, squad_member: member)
        end

        it "returns true" do
          expect(user() |> Permissions.can_update?(squad())) |> to(eq true)
        end

        context "and this is not a target squad" do
          it "returns false" do
            expect(user() |> Permissions.can_update?(another_squad())) |> to(eq false)
          end
        end
      end

      context "if user() is a student" do
        let :user do
          member = insert(:squad_member)
          insert(:user, squad_member: member)
        end

        it "returns false" do
          expect(user() |> Permissions.can_update?(squad())) |> to(eq false)
        end
      end
    end

    context "when checking squad_request" do
      context "if approver is a commander of the squad" do
        it "returns true" do
          expect(user() |> Permissions.can_update?(request())) |> to(eq true)
        end

        context "and this is not a squad of a request" do
          it "returns false" do
            expect(user() |> Permissions.can_update?(request_to_another_squad())) |> to(eq false)
          end
        end
      end

      context "if approver is a deputy_commander of the squad" do
        let :user do
          member = insert(:squad_member, role: :deputy_commander)
          insert(:user, squad_member: member)
        end

        it "returns true" do
          expect(user() |> Permissions.can_update?(request())) |> to(eq true)
        end

        context "and this is not a squad of a request" do
          it "returns false" do
            expect(user() |> Permissions.can_update?(request_to_another_squad())) |> to(eq false)
          end
        end
      end

      context "if approver is a journalist of the squad" do
        let :user do
          member = insert(:squad_member, role: :journalist)
          insert(:user, squad_member: member)
        end

        it "returns true" do
          expect(user() |> Permissions.can_update?(request())) |> to(eq true)
        end

        context "and this is not a squad of a request" do
          it "returns false" do
            expect(user() |> Permissions.can_update?(request_to_another_squad())) |> to(eq false)
          end
        end
      end

      context "if approver is a student" do
        let :user do
          member = insert(:squad_member)
          insert(:user, squad_member: member)
        end

        it "returns false" do
          expect(user() |> Permissions.can_update?(request())) |> to(eq false)
        end
      end
    end
  end

  describe "can_delete?/2" do
    context "when checking squad" do
      context "if user is a commander of the squad" do
        it "returns true" do
          expect(user() |> Permissions.can_delete?(squad())) |> to(eq true)
        end

        context "and this is not a target squad" do
          it "returns false" do
            expect(user() |> Permissions.can_update?(another_squad())) |> to(eq false)
          end
        end
      end

      context "if user is a deputy_commander of the squad" do
        let :user do
          member = insert(:squad_member, role: :deputy_commander)
          insert(:user, squad_member: member)
        end

        it "returns false" do
          expect(user() |> Permissions.can_delete?(squad())) |> to(eq false)
        end
      end

      context "if user is a journalist of the squad" do
        let :user do
          member = insert(:squad_member, role: :journalist)
          insert(:user, squad_member: member)
        end

        it "returns false" do
          expect(user() |> Permissions.can_delete?(squad())) |> to(eq false)
        end
      end

      context "if user is a student" do
        let :user do
          member = insert(:squad_member)
          insert(:user, squad_member: member)
        end

        it "returns false" do
          expect(user() |> Permissions.can_delete?(squad())) |> to(eq false)
        end
      end
    end

    context "when checking squad_request" do
      context "if user is a commander of the squad" do
        it "returns true" do
          expect(user() |> Permissions.can_delete?(request())) |> to(eq true)
        end

        context "and this is not a squad of a request" do
          it "returns false" do
            expect(user() |> Permissions.can_delete?(request_to_another_squad())) |> to(eq false)
          end
        end
      end

      context "if user is a deputy_commander of the squad" do
        let :user do
          member = insert(:squad_member, role: :deputy_commander)
          insert(:user, squad_member: member)
        end

        it "returns true" do
          expect(user() |> Permissions.can_delete?(request())) |> to(eq true)
        end

        context "and this is not a squad of a request" do
          it "returns false" do
            expect(user() |> Permissions.can_delete?(request_to_another_squad())) |> to(eq false)
          end
        end
      end

      context "if user is a journalist of the squad" do
        let :user do
          member = insert(:squad_member, role: :journalist)
          insert(:user, squad_member: member)
        end

        it "returns true" do
          expect(user() |> Permissions.can_delete?(request())) |> to(eq true)
        end

        context "and this is not a squad of a request" do
          it "returns false" do
            expect(user() |> Permissions.can_delete?(request_to_another_squad())) |> to(eq false)
          end
        end
      end

      context "if user is a student" do
        let :user do
          member = insert(:squad_member)
          insert(:user, squad_member: member)
        end

        it "returns false" do
          expect(user() |> Permissions.can_delete?(request())) |> to(eq false)
        end
      end

      context "when user is a creator of squad_request" do
        let :user do
          insert(:user)
        end

        let :request do
          insert(:squad_request, user: user())
        end

        it "returns true" do
          expect(user() |> Permissions.can_delete?(request())) |> to(eq true)
        end
      end
    end
  end
end
