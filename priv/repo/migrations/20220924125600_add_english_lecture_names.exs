defmodule Klausurarchiv.Repo.Migrations.AddEnglishLectureNames do
  use Ecto.Migration

  def change do
    alter table("lectures") do
      remove(:name, :string)
      add(:name_de, :string)
      add(:name_en, :string)
    end
  end
end
