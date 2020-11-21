defmodule Squadster.Repo.Migrations.AddLessonTypeAndClassroomToLessons do
  use Ecto.Migration

  def change do
    alter table(:lessons) do
      add :classroom, :string
      add :type, :string
    end
  end
end
