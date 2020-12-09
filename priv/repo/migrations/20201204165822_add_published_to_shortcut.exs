defmodule Klausurarchiv.Repo.Migrations.AddPublishedToShortcut do
  use Ecto.Migration

  def change do
    alter table :shortcuts do
      add :published, :boolean
    end
  end
end
