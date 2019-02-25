defmodule Klausurarchiv.Repo.Migrations.CreateDataStructure do
  use Ecto.Migration

  def up do
    TermTypeEnum.create_type()

    alter table(:terms) do
      add(:type, :term_type)
    end
  end

  def down do
    alter table(:terms) do
      remove(:type)
    end

    TermTypeEnum.drop_type()
  end
end
