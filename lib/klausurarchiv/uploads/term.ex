defmodule Klausurarchiv.Uploads.Term do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "terms" do
    field(:type, TermTypeEnum, default: :summer_term)
    field(:year, :integer)

    has_many(:exams, Klausurarchiv.Uploads.Exam)

    timestamps()
  end

  @doc false
  def changeset(exam, attrs) do
    exam
    |> cast(attrs, [:filename, :term, :lecture])
    |> validate_required([:filename, :term, :lecture])
  end
end
