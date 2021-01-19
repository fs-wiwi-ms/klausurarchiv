defmodule Absolventenfeier.Repo.Migrations.AddSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all, type: :uuid))

      add(:access_token, :string)
      add(:access_token_issued_at, :utc_datetime)

      add(:refresh_token, :string)
      add(:refresh_token_issued_at, :utc_datetime)

      add(:ip, :string)
      add(:user_agent, :string)

      timestamps()
    end

    create(index(:sessions, [:user_id]))
  end
end
