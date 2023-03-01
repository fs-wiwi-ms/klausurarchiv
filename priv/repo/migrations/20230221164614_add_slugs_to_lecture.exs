defmodule Klausurarchiv.Repo.Migrations.AddSlugsToLecture do
  use Ecto.Migration

  def change do
    alter table("lectures") do
      add(:slug, :string, unique: true)
    end

    create(unique_index("lectures", :slug))
  end
end
