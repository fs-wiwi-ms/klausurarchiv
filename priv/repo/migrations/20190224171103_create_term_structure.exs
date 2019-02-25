defmodule Klausurarchiv.Repo.Migrations.CreateTermStructure do
  use Ecto.Migration

  def change do
    create table(:terms, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:year, :integer)

      timestamps()
    end
  end
end
