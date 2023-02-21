defmodule Klausurarchiv.Repo.Migrations.AddAttachmentsToExam do
  use Ecto.Migration

  def change do
    alter table(:exams) do
      add(:attachment_id, references(:attachments, type: :uuid))
    end
  end
end
