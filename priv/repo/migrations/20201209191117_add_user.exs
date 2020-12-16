defmodule Absolventenfeier.Repo.Migrations.AddUser do
  use Ecto.Migration

  def up do
    UserRole.create_type()

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string
      add :fore_name, :string
      add :last_name, :string
      add :matriculation_number, :string
      add :password_hash, :string

      add :role, :user_role

      timestamps()
    end

    create unique_index(:users, :email)

    # create table("game_users", primary_key: false) do
    #   add :user_id, references(:user, type: :string), primary_key: true

    #   add :game_id, references(:game, type: :uuid), primary_key: true
    # end
  end

  def down do
    drop table(:users)

    UserRole.drop_type()
  end
end
