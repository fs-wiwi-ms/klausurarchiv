defmodule Klausurarchiv.Repo.Migrations.RemoveFileNameFromExam do
  use Ecto.Migration

  def change do
    alter table(:exams) do
      remove(:filename)
    end
  end
end
