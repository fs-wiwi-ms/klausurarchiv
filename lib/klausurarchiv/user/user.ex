defmodule Klausurarchiv.Users.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: false

  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field(:email, :string)
    field(:fore_name, :string)
    field(:last_name, :string)
    field(:matriculation_number, :string)

    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:role, UserRole, default: :user)
    field(:filter_data, :map, default: %{})

    field(:email_confirmed, :boolean)

    has_many(:sessions, Klausurarchiv.Users.Session)
    has_many(:user_tokens, Klausurarchiv.Users.UserToken)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :fore_name,
      :last_name,
      :matriculation_number,
      :password,
      :role,
      :filter_data,
      :email_confirmed
    ])
  end

  def changeset_create(user, attrs) do
    user
    |> changeset(attrs)
    |> validate_password
    |> validate_email
    |> validate_required([:email, :fore_name, :last_name])
    |> unique_constraint(:email)
  end

  def changeset_password(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_password()
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_confirmation(:password, required: true)
    |> validate_format(:password, ~r/[A-Z]/, message: "Missing uppercase")
    |> validate_format(:password, ~r/[a-z]/, message: "Missing lowercase")
    |> validate_format(:password, ~r/[^a-zA-Z0-9]/, message: "Missing symbol")
    |> validate_format(:password, ~r/[0-9]/, message: "Missing number")
    |> validate_length(:password, min: 8)
    |> put_pass_hash()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_confirmation(:email, required: true)
    |> validate_format(:email, ~r/[a-zA-Z0-9+_.-]+@(uni-muenster|wwu)?\.de/,
      message: "Email must end with @uni-muenster.de or @wwu.de"
    )
  end

  defp put_pass_hash(%{valid?: true, changes: %{password: pw}} = changeset) do
    change(changeset, Argon2.add_hash(pw))
  end

  defp put_pass_hash(changeset), do: changeset
end
