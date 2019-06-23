defmodule Klausurarchiv.Repo.Migrations.AddPublishFieldToExam do
  use Ecto.Migration

  def up do
    alter table(:exams) do
      add(:published, :bool, default: true)
    end

    execute("Update exams Set published=TRUE")
  end

  def down do
    alter table(:exams) do
      remove(:published)
    end
  end
end
