defmodule Klausurarchiv.Repo.Migrations.RenamePasswordResetTokensToUserTokens do
  use Ecto.Migration

  def change do
    rename(table("password_reset_tokens"), to: table("user_tokens"))
  end
end
