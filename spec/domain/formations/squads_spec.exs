defmodule Squadster.Domain.Formations.SquadsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Formations.Squad

  describe "changeset" do
    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{squad_number: "123456", class_day: :monday} |> Squad.changeset
        expect is_valid |> to(be true)
      end
    end

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
end
