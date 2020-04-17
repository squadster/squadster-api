defmodule Squadster.Domain.SquadRequestsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Formations.SquadRequest

  let :user, do: insert(:user)
  let! :squad, do: build(:squad) |> with_commander(user()) |> insert

  describe "changeset" do
    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{user_id: 1, squad_id: 1} |> SquadRequest.changeset
        expect is_valid |> to(be true)
      end
    end

    context "when user is not set" do
      it "is not valid" do
        %{valid?: is_valid} = %{user_id: 1} |> SquadRequest.changeset
        expect is_valid |> to(be false)
      end
    end

    context "when squad is not set" do
      it "is not valid" do
        %{valid?: is_valid} = %{squad_id: 1} |> SquadRequest.changeset
        expect is_valid |> to(be false)
      end
    end
  end

  describe "approve_changeset" do
    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{user_id: 1, squad_id: 1, approver_id: 2} |> SquadRequest.approve_changeset
        expect is_valid |> to(be true)
      end

      it "sets approved_at to current time" do
        %{changes: %{approved_at: approved_at}} =
          %{user_id: 1, squad_id: 1, approver_id: 2}
          |> SquadRequest.approve_changeset
        expect approved_at |> to_not(be_nil())
      end
    end

    context "when user is not set" do
      it "is not valid" do
        %{valid?: is_valid} = %{user_id: 1, approver_id: 2} |> SquadRequest.approve_changeset
        expect is_valid |> to(be false)
      end
    end

    context "when squad is not set" do
      it "is not valid" do
        %{valid?: is_valid} = %{squad_id: 1, approver_id: 2} |> SquadRequest.approve_changeset
        expect is_valid |> to(be false)
      end
    end

    context "when approver is not set" do
      it "is not valid" do
        %{valid?: is_valid} = %{user_id: 1, squad_id: 1} |> SquadRequest.approve_changeset
        expect is_valid |> to(be false)
      end
    end
  end
end
