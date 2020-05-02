defmodule Squadster.Workers.NormalizeQueueSpec do
  use ESpec.Phoenix, async: true
  use ESpec.Phoenix.Extend, :worker

  alias Squadster.Workers.NormalizeQueue

  let :squad, do: insert(:squad)

  describe "run/1" do
    describe "empty queue_numbers" do
      #context "when management roles are in queue" do

      before do
        insert(:squad_member, squad: squad(), user: insert(:user), role: :commander, queue_number: 1)

        for _ <- (1..5) do
          insert(:squad_member, squad: squad(), user: insert(:user), role: :student, queue_number: nil)
        end
      end

      it "sets queue_number for students with nil queue_number" do
        NormalizeQueue.run([squad_id: squad().id])

        %{members: members} = squad() |> Repo.preload(:members)
        members
        |> Enum.reject(fn member -> member.role == :commander end)
        |> Enum.each(fn member -> expect(member.queue_number) |> to_not(be nil) end)
      end

      it "sets queue_number to nil for management roles" do
        NormalizeQueue.run([squad_id: squad().id])

        %{members: members} = squad() |> Repo.preload(:members)
        members
        |> Enum.filter(fn member -> member.role == :commander end)
        |> Enum.each(fn member -> expect(member.queue_number) |> to(be nil) end)
      end
    end

    describe "holes in queue" do
      before do
        for index <- (1..5) do
          insert(:squad_member, squad: squad(), user: insert(:user), role: :student, queue_number: index + 2)
        end
      end

      it "removes existing holes" do
        NormalizeQueue.run([squad_id: squad().id])

        %{members: members} = squad() |> Repo.preload(:members)
        members
        |> Enum.sort_by(fn member -> member.queue_number end)
        |> Enum.with_index
        |> Enum.each(fn {member, index} -> expect(member.queue_number) |> to(eq index + 1) end)
      end
    end
  end
end
