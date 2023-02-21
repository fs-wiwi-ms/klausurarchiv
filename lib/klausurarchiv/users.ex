defmodule Klausurarchiv.Users do
  import Ecto.Query, warn: false

  alias Klausurarchiv.Repo
  alias Klausurarchiv.Users.{UserToken, User}

  require Logger

  # -----------------------------------------------------------------
  # -- User
  # -----------------------------------------------------------------

  def get_users() do
    User
    |> Repo.all()
  end

  def get_administrator_users() do
    User
    |> where([u], u.role == ^"admin")
    |> Repo.all()
  end

  def get_user(nil), do: nil

  def get_user(id) do
    User
    |> Repo.get(id)
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_token(%Klausurarchiv.Users.UserToken{} = token) do
    token
    |> Ecto.assoc(:user)
    |> Repo.one()
  end

  def create_user(user_params) do
    result =
      %User{}
      |> User.changeset_create(user_params)
      |> Repo.insert()

    case result do
      {:ok, user} ->
        {:ok, _} = UserToken.create_account_confirmation_token(user)
        result

      error ->
        error
    end
  end

  def update_user(user, user_params) do
    user
    |> change_user(user_params)
    |> Repo.update()
  end

  def change_user(user \\ %User{}, user_params \\ %{}) do
    user
    |> User.changeset(user_params)
  end

  def change_user_password(user, user_params) do
    user
    |> User.changeset_password(user_params)
    |> Repo.update()
  end
end
