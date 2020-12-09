defmodule Klausurarchiv.Uploads.Shortcut do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "shortcuts" do
    field(:name, :string)
    field(:published, :boolean)

    belongs_to(:lecture, Klausurarchiv.Uploads.Lecture)

    timestamps()
  end

  @doc false
  def changeset(shortcut, attrs) do
    shortcut
    |> cast(attrs, [:name, :published])
    |> validate_required([:name])
    |> put_assoc(:lecture, attrs["lecture"] || shortcut.lecture)
  end
end
