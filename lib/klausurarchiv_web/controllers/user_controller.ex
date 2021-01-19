defmodule KlausurarchivWeb.UserController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.User

  def new(conn, _params) do
    user_changeset = User.change_user()

    render(conn, "new.html",
      changeset: user_changeset,
      action: public_user_path(conn, :create)
    )
  end

  def create(conn, %{"user" => user}) do
    case User.create_user(user) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("Registration successful! Please login."))
        |> redirect(to: public_session_path(conn, :new))

      {:error, changeset} ->
        conn
        |> put_flash(:error, gettext("Error while creating user!"))
        |> render("new.html",
          changeset: changeset,
          action: public_user_path(conn, :create)
        )
    end
  end
end
