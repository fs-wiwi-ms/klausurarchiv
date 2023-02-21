defmodule KlausurarchivWeb.PasswordResetTokenController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Users
  alias Klausurarchiv.Users.{UserToken, User}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email}) do
    if user = Users.get_user_by_email(email) do
      UserToken.create_password_reset_token(user)
    end

    conn
    |> put_flash(:info, gettext("We have sent you a mail"))
    |> redirect(to: public_session_path(conn, :new))
  end

  def show(conn, %{"id" => token}) do
    case UserToken.get_valid_token(token) do
      nil ->
        conn
        |> put_flash(:error, gettext("Link is not valid"))
        |> redirect(to: "/")

      token ->
        changeset =
          token
          |> Users.get_user_by_token()
          |> Users.change_user()

        render(conn, "show.html",
          token: token,
          changeset: changeset,
          action: public_password_reset_token_path(conn, :update, token)
        )
    end
  end

  def update(conn, %{"user" => user_params, "id" => token}) do
    token = UserToken.get_token(token)

    with %UserToken{} <- token,
         user = %User{} <- token.user,
         {:ok, _user} <- Users.change_user_password(user, user_params),
         {:ok, _token} <- UserToken.delete_password_reset_token(token) do
      conn
      |> put_flash(:info, gettext("Password changed succesful"))
      |> redirect(to: public_session_path(conn, :new))
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Link is not valid"))
        |> redirect(to: "/")

      {:error, changeset} ->
        conn
        |> put_flash(:error, gettext("Could not update password."))
        |> render("show.html",
          token: token,
          changeset: changeset,
          action: public_password_reset_token_path(conn, :update, token)
        )
    end
  end
end
