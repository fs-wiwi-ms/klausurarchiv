defmodule Klausurarchiv.Uploads.Exam do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "exams" do
    field(:filename, :string)
    field(:published, :boolean, default: false)

    belongs_to(:term, Klausurarchiv.Uploads.Term)
    belongs_to(:lecture, Klausurarchiv.Uploads.Lecture)

    timestamps()
  end

  @doc false
  def changeset(exam, attrs) do
    exam
    |> cast(attrs, [:filename, :term_id, :lecture_id, :published])
  end

    @doc false
    def changeset_create(exam, attrs) do
      exam
      |> changeset(attrs)
      |> validate_required([:filename, :term_id, :lecture_id])
    end
end
