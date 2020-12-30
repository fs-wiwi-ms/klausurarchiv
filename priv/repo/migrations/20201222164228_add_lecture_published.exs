defmodule Klausurarchiv.Repo.Migrations.AddLecturePublished do
  use Ecto.Migration

  def change do
    alter table :lectures do
      add :published, :boolean, default: true
    end

    execute(fn -> repo().update_all("lectures", set: [published: true]) end)
  end
end
