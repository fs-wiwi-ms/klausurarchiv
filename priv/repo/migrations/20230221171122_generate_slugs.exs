defmodule Klausurarchiv.Repo.Migrations.GenerateSlugs do
  use Ecto.Migration

  alias Klausurarchiv.Repo
  alias Klausurarchiv.Uploads.Lecture
  import Ecto.Query

  def up do
    lectures =
      Lecture
      |> preload([:degrees, :shortcuts])
      |> Repo.all()

    for lecture <- lectures do
      lecture
      |> Lecture.changeset(%{})
      |> Repo.update()
    end
  end

  def down do
  end
end
