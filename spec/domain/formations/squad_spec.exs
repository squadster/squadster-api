defmodule Squadster.Domain.Formations.SquadSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Formations.Squad

  describe "changeset" do
    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{squad_number: "123456", class_day: :monday} |> Squad.changeset
        expect is_valid |> to(be true)
      end
    end

    context "when params are invalid" do
      context "when squad_member is not set" do
        it "is not valid" do
          %{valid?: is_valid} = %{class_day: :monday} |> Squad.changeset
          expect is_valid |> to(be false)
        end
      end

      context "when class_day is not set" do
        it "is not valid" do
          %{valid?: is_valid} = %{squad_number: "123456"} |> Squad.changeset
          expect is_valid |> to(be false)
        end
      end
    end
  end

  describe "commander/1" do
    let :user, do: insert(:user)
    let! :squad, do: build(:squad) |> with_commander(user()) |> insert

    it "returns commander for given squad" do
      %{squad_member: commander} = user() |> Repo.preload(:squad_member)
      expect squad()
      |> Squad.commander()
      |> to(eq commander)
    end
  end

  describe "load/1" do
    let :squad, do: insert(:squad)

    it "loads hash_id of the given squad" do
      expect squad()
      |> Squad.load()
      |> Map.get(:hash_id)
      |> is_binary
      |> to(be true)
    end

    context "when squad is nil" do
      it "returns nil" do
        expect nil
        |> Squad.load()
        |> to(be nil)
      end
    end
  end
end
