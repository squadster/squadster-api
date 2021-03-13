defmodule Squadster.Domain.Accounts.UserSettingsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :domain

  alias Squadster.Accounts.UserSettings

  describe "changeset functions" do
    context "when params are valid" do
      it "is valid" do
        %{valid?: is_valid} = %{user_id: Enum.random(1..100)} |> UserSettings.changeset

        expect is_valid |> to(be true)
      end
    end

    context "when params are invalid" do
      it "is invalid" do
        %{valid?: is_valid} = %{} |> UserSettings.changeset

        expect is_valid |> to(be false)
      end
    end
  end
end
