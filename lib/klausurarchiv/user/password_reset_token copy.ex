defmodule Klausurarchiv.User.PasswordResetToken do
  @moduledoc """
  Represents the database entity password reset tokens, that are emailed to
  users to enable them to reset their passwords.
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Klausurarchiv.{Token, Repo, Mailer}
  alias Klausurarchiv.User.{PasswordResetToken, Email}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "password_reset_tokens" do
    field(:token, :string)

    belongs_to(:user, Klausurarchiv.User)

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> put_change(:token, Token.generate())
  end

  # ---------------------------------------------------------------------------------
  # -------- Password Reset
  # ---------------------------------------------------------------------------------

  def get_token(token) do
    PasswordResetToken
    |> Repo.get(token)
    |> Repo.preload(:user)
  end

  def get_valid_token(token) do
    hr_ago = Token.one_hour_ago()

    PasswordResetToken
    |> where([t], t.token == ^token and t.inserted_at >= ^hr_ago)
    |> Repo.one()
  end

  def create_password_reset_token(user) do
    token =
      user
      |> Ecto.build_assoc(:password_reset_tokens)
      |> PasswordResetToken.changeset(%{})
      |> Repo.insert()

    case token do
      {:ok, token} ->
        user
        |> Email.password_reset_email(token)
        |> Mailer.deliver_now()

      _other ->
        nil
    end
  end

  def delete_password_reset_token(token) do
    Repo.delete(token)
  end
end
