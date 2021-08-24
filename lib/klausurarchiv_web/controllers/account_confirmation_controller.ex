defmodule KlausurarchivWeb.AccountConfirmationController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.User.UserToken
  alias Klausurarchiv.User

  def show(conn, attrs) do
  end

  def new(conn, attrs) do
    user =
      conn
      |> get_session(:user_id)
      |> User.get_user()

    conn
    |> render("new.html",
        user: user,
        action: account_confirmation_path(conn, :create)
      )
  end

  def create(conn, attrs) do
    user =
      conn
      |> get_session(:user_id)
      |> User.get_user()

    case UserToken.create_account_confirmation_token(user) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "Sent account confirmation mail!")
        |> redirect(to: page_path(conn, :index))

      {:error, _ } ->
        conn
        |> put_flash(:error, "Could not send the account confirmation mail.")
        |> redirect(to: page_path(conn, :index))
    end
  end
end
