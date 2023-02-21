defmodule Klausurarchiv.Users.Session do
  @moduledoc """
  Session are used to authenticate users. They are limited regarding their
  validity.
  """

  import Ecto.{Query}
  import Ecto.Changeset

  alias Klausurarchiv.{
    Repo,
    Token
  }

  alias Klausurarchiv.Users.{User, Session}

  use Ecto.Schema

  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "sessions" do
    field(:user_agent, :string)
    field(:ip, :string)

    field(:access_token, :string)
    field(:access_token_issued_at, :utc_datetime)
    field(:refresh_token, :string)
    field(:refresh_token_issued_at, :utc_datetime)

    belongs_to(:user, Klausurarchiv.Users.User)

    timestamps()
  end

  defp changeset(session, %{refresh_token: false} = attrs) do
    session
    |> cast(attrs, [:user_agent, :ip])
    |> validate_required([:user_agent, :ip])
    |> put_change(:access_token, Token.generate())
    |> put_change(
      :access_token_issued_at,
      DateTime.truncate(Timex.now(), :second)
    )
  end

  defp changeset(session, attrs) do
    session
    |> changeset(%{attrs | refresh_token: false})
    |> put_change(:refresh_token, Token.generate())
    |> put_change(
      :refresh_token_issued_at,
      DateTime.truncate(Timex.now(), :second)
    )
  end

  # 1 day
  @access_token_validity 24 * 60 * 60

  # Returns wether a session has a valid access token.
  defp valid_access_token?(_, nil), do: false

  defp valid_access_token?(session, access_token) do
    session.access_token == access_token &&
      DateTime.diff(Timex.now(), session.access_token_issued_at) <
        @access_token_validity
  end

  # 90 days
  @refresh_token_validity 90 * 24 * 60 * 60

  # Returns wether a session's refresh token is valid.
  defp valid_refresh_token?(_, nil), do: false

  defp valid_refresh_token?(session, refresh_token) do
    session.refresh_token == refresh_token &&
      DateTime.diff(Timex.now(), session.refresh_token_issued_at) <
        @refresh_token_validity
  end

  # -----------------------------------------------------------------
  # -- Session
  # -----------------------------------------------------------------

  @doc """
  Verifies a session given an access token and (optional) a refresh token.
  Returns the session with its user included.

  If the access token is expired but the refresh token is valid it will issue
  a new set of tokens which will be included in the returned session.
  """
  def verify_session(access_token, refresh_token)

  def verify_session(nil, nil) do
    {:error, :no_session}
  end

  def verify_session(access_token, refresh_token) do
    query = preload(Session, :user)

    query =
      case {access_token, refresh_token} do
        {nil, refresh_token} ->
          query
          |> where(refresh_token: ^refresh_token)

        {access_token, nil} ->
          query
          |> where(access_token: ^access_token)

        {access_token, refresh_token} ->
          query
          |> where(access_token: ^access_token)
          |> or_where(refresh_token: ^refresh_token)
      end

    session = Repo.one(query)

    cond do
      is_nil(session) ->
        {:error, :not_found}

      valid_access_token?(session, access_token) ->
        {:ok, session}

      valid_refresh_token?(session, refresh_token) ->
        session
        |> changeset(%{refresh_token: true})
        |> Repo.update()

      not is_nil(refresh_token) ->
        Repo.delete(session)
        {:error, :invalid}

      true ->
        {:error, :invalid_session}
    end
  end

  @doc "Fetches a session"
  def get_session!(id) do
    Repo.get!(Klausurarchiv.Users.Session, id)
  end

  @doc "Creates a session for a user identified by email and password"
  def create_session(email, password, params) do
    with {:ok, user} <-
           User
           |> Repo.get_by(email: email)
           |> Argon2.check_pass(password),
         %Session{} = session <-
           user
           |> Ecto.build_assoc(:sessions)
           |> changeset(params)
           |> Repo.insert!()
           |> Repo.preload([:user]) do
      {:ok, session}
    else
      {:error, message} ->
        Logger.info("Login failed: #{message}")
        {:error, :not_found}
    end
  end

  @doc "Creates a session for a user *without verifying its password."
  def create_session(user, params) do
    user
    |> Ecto.build_assoc(:sessions)
    |> changeset(params)
    |> Repo.insert()
  end

  @doc "Delete session"
  def delete_session(session) do
    Repo.delete(session)
  end

  @doc "Clear stale sessions"
  def clear_stale_session() do
    Session
    |> where(
      [s],
      s.refresh_token_issued_at <
        datetime_add(
          ^NaiveDateTime.utc_now(),
          -@refresh_token_validity,
          "second"
        )
    )
    |> or_where(
      [s],
      s.access_token_issued_at <
        datetime_add(
          ^NaiveDateTime.utc_now(),
          -@access_token_validity,
          "second"
        ) and is_nil(s.refresh_token)
    )
    |> Repo.delete_all()
  end
end
