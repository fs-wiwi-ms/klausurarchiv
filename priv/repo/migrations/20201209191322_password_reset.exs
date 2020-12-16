defmodule Absolventenfeier.Repo.Migrations.PasswordReset do
  use Ecto.Migration

  def change do
    create table(:password_reset_tokens, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all, type: :uuid))

      add(:token, :string)

      timestamps()
    end

    create(index(:password_reset_tokens, [:user_id]))
  end
end
