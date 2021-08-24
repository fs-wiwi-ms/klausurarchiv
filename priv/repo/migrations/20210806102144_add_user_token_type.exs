defmodule Klausurarchiv.Repo.Migrations.AddUserTokenType do
  use Ecto.Migration

  def up do
    UserTokenTypeEnum.create_type()

    alter table(:user_tokens) do
      add(:type, :user_token_type, null: false)
    end
  end

  def down do
    alter table(:user_tokens) do
      remove(:type)
    end

    UserTokenTypeEnum.drop_type()
  end
end
