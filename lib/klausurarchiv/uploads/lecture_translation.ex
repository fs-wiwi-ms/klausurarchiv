defmodule Klausurarchiv.Uploads.LectureTranslation do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :country_code, :string
  end

  @doc false
  def changeset(lecture_translation, attrs) do
    lecture_translation
    |> cast(attrs, [:name, :country_code])
    |> validate_required([:name, :country_code])
  end
end
