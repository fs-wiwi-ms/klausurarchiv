defmodule Klausurarchiv.Uploads.Lecture do
  use Ecto.Schema
  import Ecto.Changeset

  alias Klausurarchiv.Uploads.NameSlug

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "lectures" do
    field(:module_number, :string)
    field(:name, :string)
    field(:published, :boolean, default: true)
    field(:image_name, :string)
    field(:image_url, :string)

    field(:slug, NameSlug.Type)

    has_many(:exams, Klausurarchiv.Uploads.Exam)

    has_many(:shortcuts, Klausurarchiv.Uploads.Shortcut, on_replace: :delete)

    many_to_many(
      :degrees,
      Klausurarchiv.Uploads.Degree,
      join_through: "degree_lectures",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(lecture, attrs) do
    lecture
    |> cast(attrs, [:name, :module_number, :published, :image_name, :image_url])
    |> validate_required([:name])
    |> put_assoc(:shortcuts, attrs["shortcuts"] || lecture.shortcuts)
    |> put_assoc(:degrees, attrs["degrees"] || lecture.degrees)
    |> NameSlug.maybe_generate_slug()
    |> NameSlug.unique_constraint()
  end
end
