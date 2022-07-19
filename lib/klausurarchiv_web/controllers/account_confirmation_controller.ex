defmodule KlausurarchivWeb.AccountConfirmationController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.User.UserToken
  alias Klausurarchiv.User

  def confirm_mail(conn, %{"token" => token}) do
    case UserToken.get_valid_token(token) do
      nil ->
        conn
        |> put_flash(:error, gettext("Link is not valid"))
        |> redirect(to: "/")

      token ->
        User.get_user_by_token(token)
        |> User.update_user(%{email_confirmed: true})

        {:ok, _token} = UserToken.delete_password_reset_token(token)

        conn
        |> put_flash(:success, "Your email was confirmed!")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def not_confirmed(conn, _attrs) do
    user =
      conn
      |> get_session(:user_id)
      |> User.get_user()

    render(conn, "not_confirmed.html", user: user)
  end

  def send_confirmation_mail(conn, _attrs) do
    user =
      conn
      |> get_session(:user_id)
      |> User.get_user()

    case UserToken.create_account_confirmation_token(user) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "Sent account confirmation mail!")
        |> redirect(to: page_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Could not send the account confirmation mail.")
        |> redirect(to: page_path(conn, :index))
    end
  end
end
