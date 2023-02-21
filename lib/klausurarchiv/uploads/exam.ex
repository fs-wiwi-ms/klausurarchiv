defmodule Klausurarchiv.Uploads.Exam do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "exams" do
    field(:published, :boolean, default: false)

    belongs_to(:term, Klausurarchiv.Uploads.Term)
    belongs_to(:lecture, Klausurarchiv.Uploads.Lecture)
    belongs_to(:attachment, Klausurarchiv.Attachment)

    timestamps()
  end

  @doc false
  def changeset(exam, attrs) do
    exam
    |> cast(attrs, [:term_id, :lecture_id, :published])
    |> validate_required([:term_id, :lecture_id])
    |> put_assoc(:attachment, Map.get(attrs, "attachment", exam.attachment))
  end
end
