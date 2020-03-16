defmodule Squadster.Domain.Helpers.PermissionsSpec do
  use ESpec.Phoenix, async: true

  import Squadster.Support.Factory

  alias Squadster.Helpers.Permissions
  alias Squadster.Repo

  let :user do
    member = build(:squad_member) |> make_commander |> insert
    build(:user) |> with_squad_member(member) |> insert
  end

  let :squad do
    %{squad_member: %{squad: squad}} = user |> Repo.preload(squad_member: :squad)
    squad
  end

  describe "can_update?/2" do
    context "when checking squad" do
      context "if user is a commander of the squad" do
        it "returns true" do
          expect(user |> Permissions.can_update?(squad)) |> to(eq true)
        end
      end

      context "if user is a deputy_commander of the squad" do
        let :user do
          member = build(:squad_member) |> make_deputy_commander |> insert
          build(:user) |> with_squad_member(member) |> insert
        end

        it "returns true" do
          expect(user |> Permissions.can_update?(squad)) |> to(eq true)
        end
      end

      context "if user is a journalist of the squad" do
        let :user do
          member = build(:squad_member) |> make_journalist |> insert
          build(:user) |> with_squad_member(member) |> insert
        end

        it "returns true" do
          expect(user |> Permissions.can_update?(squad)) |> to(eq true)
        end
      end

      context "if user is a student" do
        let :user do
          member = insert(:squad_member)
          build(:user) |> with_squad_member(member) |> insert
        end

        it "returns false" do
          expect(user |> Permissions.can_update?(squad)) |> to(eq false)
        end
      end
    end

    context "when checking squad_request" do

    end
  end

  describe "can_delete?/2" do
    context "when checking squad" do
      context "if user is a commander of the squad" do
        it "returns true" do
          expect(user |> Permissions.can_delete?(squad)) |> to(eq true)
        end
      end

      context "if user is a deputy_commander of the squad" do
        let :user do
          member = build(:squad_member) |> make_deputy_commander |> insert
          build(:user) |> with_squad_member(member) |> insert
        end

        it "returns false" do
          expect(user |> Permissions.can_delete?(squad)) |> to(eq false)
        end
      end

      context "if user is a journalist of the squad" do
        let :user do
          member = build(:squad_member) |> make_journalist |> insert
          build(:user) |> with_squad_member(member) |> insert
        end

        it "returns false" do
          expect(user |> Permissions.can_delete?(squad)) |> to(eq false)
        end
      end

      context "if user is a student" do
        let :user do
          member = insert(:squad_member)
          build(:user) |> with_squad_member(member) |> insert
        end

        it "returns false" do
          expect(user |> Permissions.can_delete?(squad)) |> to(eq false)
        end
      end
    end

    context "when checking squad_request" do

    end
  end
end
