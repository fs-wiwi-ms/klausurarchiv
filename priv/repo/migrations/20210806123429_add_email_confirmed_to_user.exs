defmodule Klausurarchiv.Repo.Migrations.AddEmailConfirmedToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:email_confirmed, :boolean, default: false, null: false)
    end
  end
end
