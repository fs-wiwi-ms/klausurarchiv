defmodule Klausurarchiv.Repo.Migrations.RenameTableExam do
  use Ecto.Migration

  def change do
    rename table("exam"), to: table("exams")
  end
end
