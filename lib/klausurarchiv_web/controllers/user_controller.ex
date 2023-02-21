defmodule KlausurarchivWeb.UserController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Users
  alias Klausurarchiv.Users.Session

  def new(conn, _params) do
    user_changeset = Users.change_user()

    render(conn, "new.html",
      changeset: user_changeset,
      action: public_user_path(conn, :create)
    )
  end

  def create(conn, %{"user" => user}) do
    params = %{
      ip: conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
      user_agent: List.first(get_req_header(conn, "user-agent")),
      refresh_token: false
    }

    case Users.create_user(user) do
      {:ok, user} ->
        # conn
        # |> put_flash(:info, gettext("Registration successful! Please login."))
        # |> redirect(to: public_session_path(conn, :new))

        result = Session.create_session(user, params)

        case result do
          {:ok, session} ->
            path = get_session(conn, :redirect_url) || page_path(conn, :index)
            conn = delete_session(conn, :redirect_url)

            conn
            |> put_session(:access_token, session.access_token)
            |> put_flash(
              :info,
              gettext(
                "Registration successful! You are now logged in. Please verify your email to confirm your affiliation with the University of Münster. We have sent you an email with the link for confirmation."
              )
            )
            |> redirect(to: path)

          _ ->
            conn
            |> put_flash(
              :info,
              gettext("Registration successful! Please login.")
            )
            |> redirect(to: public_session_path(conn, :new))
        end

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
