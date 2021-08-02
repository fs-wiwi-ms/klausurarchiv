defmodule Klausurarchiv.Repo.Migrations.AddAttachments do
  use Ecto.Migration

  def change do
    create table(:attachments, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:location, :string)
      add(:file_name, :string)
      add(:content_type, :string)
      add(:size, :integer)

      timestamps()
    end
  end
end
