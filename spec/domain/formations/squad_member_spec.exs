defmodule Squadster.Domain.Formations.SquadMemberSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Formations.SquadMember

  describe "changeset" do
    let :user, do: insert(:user)
    let :squad, do: insert(:squad)

    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{role: :student, user_id: user().id, squad_id: squad().id} |> SquadMember.changeset
        expect is_valid |> to(be true)
      end
    end

    context "when params are invalid" do
      context "when role is not set" do
        it "is not valid" do
        %{valid?: is_valid} = %{user_id: user().id, squad_id: squad().id} |> SquadMember.changeset
          expect is_valid |> to(be false)
        end
      end

      context "when user is not set" do
        it "is not valid" do
          %{valid?: is_valid} = %{role: :student, squad_id: squad().id} |> SquadMember.changeset
          expect is_valid |> to(be false)
        end
      end

      context "when squad is not set" do
        it "is not valid" do
          %{valid?: is_valid} = %{role: :student, user_id: user().id} |> SquadMember.changeset
          expect is_valid |> to(be false)
        end
      end
    end
  end

  describe "parse_role/1" do
    it "returns atom value for given integer role" do
      expect(SquadMember.parse_role(2)) |> to(eq :journalist)
    end
  end

  describe "serialize_role/1" do
    it "returns string value for given atom role" do
      expect(SquadMember.serialize_role(:journalist)) |> to(eq "journalist")
    end
  end
end
