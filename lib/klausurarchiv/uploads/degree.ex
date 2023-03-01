defmodule Klausurarchiv.Uploads.Degree do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "degrees" do
    field(:name, :string)

    many_to_many(
      :lectures,
      Klausurarchiv.Uploads.Lecture,
      join_through: "degree_lectures",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(degree, attrs) do
    degree
    |> cast(attrs, [:name])
    |> cast_assoc(:lectures, attrs["lectures"] || degree.lectures)
  end
end
