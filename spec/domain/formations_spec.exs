defmodule Squadster.Domain.FormationsSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :model

  alias Squadster.Formations
  alias Squadster.Formations.Squad

  let :user, do: insert(:user)

  describe "list_squads/0" do
    it "returns list of squads" do
      squads_count = entities_count(Squad)
      expect Formations.list_squads()
      |> Enum.count
      |> to(eq squads_count)
    end
  end

  describe "create_squad/2" do
    let :create_params, do: %{squad_number: "123456", class_day: 3}

    it "creates a new squad with valid attributes" do
      previous_count = entities_count(Squad)

      Formations.create_squad(create_params(), user())

      expect entities_count(Squad) |> to(eq previous_count + 1)
    end

    it "sets creator as a commander" do
      Formations.create_squad(create_params(), user())

      %{squad_member: member} = user() |> Repo.preload(:squad_member)

      expect(Squad |> last |> Squad.commander) |> to(eq member)
    end
  end

  describe "delete_squad/2" do
    it "deletes a squad by id" do
      %{id: squad_id} = build(:squad) |> with_commander(user()) |> insert
      previous_count = entities_count(Squad)

      Formations.delete_squad(squad_id, user())

      expect entities_count(Squad) |> to(eq previous_count - 1)
    end
  end

  describe "update_squad/2" do
    let :squad, do: build(:squad) |> with_commander(user()) |> insert
    let :update_params, do: %{
      id: squad().id,
      squad_number: "123456",
      advertisment: "~\-o-/~  <  wub-wub-wub",
      class_day: 4
    }

    it "updates a squad by id" do
      Formations.update_squad(update_params(), user())

      expect Repo.get(Squad, squad().id).advertisment |> to(eq update_params().advertisment)
      expect {:ok, Repo.get(Squad, squad().id).class_day} |> to(eq Squad.ClassDayEnum.cast(update_params().class_day))
      expect Repo.get(Squad, squad().id).squad_number |> to(eq update_params().squad_number)
    end
  end
end
