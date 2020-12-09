defmodule Klausurarchiv.Repo.Migrations.AddShortToLecture do
  use Ecto.Migration

  def change do
    create table("shortcuts", primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)

      add(
        :lecture_id,
        references(:lectures, type: :uuid)
      )

      timestamps()
    end
  end
end
