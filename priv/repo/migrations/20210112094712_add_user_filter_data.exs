defmodule Klausurarchiv.Repo.Migrations.AddUserFilterData do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:filter_data, :map)
    end
  end
end
