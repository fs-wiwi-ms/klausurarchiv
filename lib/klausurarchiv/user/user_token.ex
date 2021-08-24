defmodule Klausurarchiv.User.UserToken do
  @moduledoc """
  Represents the database entity password reset tokens, that are emailed to
  users to enable them to reset their passwords.
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Klausurarchiv.{Token, Repo, Mailer}
  alias Klausurarchiv.User.{UserToken, Email}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_tokens" do
    field(:token, :string)
    field(:type, UserTokenTypeEnum, default: :account_confirmation)

    belongs_to(:user, Klausurarchiv.User)

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:user_id, :type])
    |> validate_required([:user_id])
    |> put_change(:token, Token.generate())
  end

  # ---------------------------------------------------------------------------------
  # -------- Password Reset
  # ---------------------------------------------------------------------------------

  def get_token(token) do
    UserToken
    |> Repo.get(token)
    |> Repo.preload(:user)
  end

  def get_valid_token(token) do
    hr_ago = Token.one_hour_ago()

    UserToken
    |> where([t], t.token == ^token and t.inserted_at >= ^hr_ago)
    |> Repo.one()
  end

  def create_password_reset_token(user) do
    token = create_token(user, :password_reset)

    case token do
      {:ok, token} ->
        user
        |> Email.password_reset_email(token)
        |> Mailer.deliver_now()

      _other ->
        nil
    end
  end

  def create_account_confirmation_token(user) do
    token = create_token(user, :account_confirmation)

    case token do
      {:ok, token} ->
        user
        |> Email.account_confirmation_email(token)
        |> Mailer.deliver_now()

      _other ->
        nil
    end
  end

  defp create_token(user, type) do
    token =
      user
      |> Ecto.build_assoc(:user_tokens)
      |> UserToken.changeset(%{type: type})
      |> Repo.insert()
  end

  def delete_password_reset_token(token) do
    Repo.delete(token)
  end
end
