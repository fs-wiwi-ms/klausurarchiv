defmodule Klausurarchiv.Uploads.Exam do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "exams" do
    field(:filename, :string)

    belongs_to(:term, Klausurarchiv.Uploads.Term)
    belongs_to(:lecture, Klausurarchiv.Uploads.Term)

    timestamps()
  end

  @doc false
  def changeset(exam, attrs) do
    exam
    |> cast(attrs, [:filename, :term, :lecture])
    |> validate_required([:filename, :term, :lecture])
  end
end
