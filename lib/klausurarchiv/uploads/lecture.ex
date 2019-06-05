defmodule Klausurarchiv.Uploads.Lecture do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "lectures" do
    field(:name, :string)

    has_many(:exams, Klausurarchiv.Uploads.Exam)

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
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_assoc(:degrees, attrs["degrees"] || lecture.degrees)
  end
end
