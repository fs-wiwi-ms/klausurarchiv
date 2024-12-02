defmodule Klausurarchiv.Repo.Migrations.AddTranslations do
  use Ecto.Migration

  def change do

    alter table("lectures") do
      add :lecture_translations, :map
    end
  end
end
