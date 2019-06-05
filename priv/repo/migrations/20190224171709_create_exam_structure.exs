defmodule Klausurarchiv.Repo.Migrations.CreateExamStructure do
  use Ecto.Migration

  def change do
    create table("exam", primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:filename, :string)

      add(
        :lecture_id,
        references(:lectures, type: :uuid)
      )

      add(
        :term_id,
        references(:terms, type: :uuid)
      )

      timestamps()
    end

    create table(:degree_lectures, primary_key: false) do
      add(:degree_id, references(:degrees, type: :uuid, on_delete: :delete_all))

      add(
        :lecture_id,
        references(:lectures, type: :uuid, on_delete: :delete_all)
      )
    end
  end
end
