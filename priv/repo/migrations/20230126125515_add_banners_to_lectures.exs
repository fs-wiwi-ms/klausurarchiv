defmodule Klausurarchiv.Repo.Migrations.AddBannersToLectures do
  use Ecto.Migration

  def change do
    alter table(:lectures) do
      add(:image_name, :string)
      add(:image_url, :string)
    end
  end
end
