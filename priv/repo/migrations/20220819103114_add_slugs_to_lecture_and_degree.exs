defmodule Klausurarchiv.Repo.Migrations.AddSlugsToLectureAndDegree do
  use Ecto.Migration

  def change do
    alter table("lectures") do
      add(:slug, :string, unique: true)
    end

    create(unique_index("lectures", :slug))
  end
end
