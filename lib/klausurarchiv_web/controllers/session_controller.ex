defmodule KlausurarchivWeb.SessionController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.User.Session

  def new(conn, _params) do
    render(conn, "new.html", %{
      action: public_session_path(conn, :create)
    })
  end

  def create(conn, %{"email" => email, "password" => password} = session) do
    format = get_format(conn)

    params = %{
      ip: conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
      user_agent: List.first(get_req_header(conn, "user-agent")),
      refresh_token: session["remember_me"] == "true"
    }

    result = Session.create_session(email, password, params)

    case {format, result} do
      {"html", {:ok, session}} ->
        path = get_session(conn, :redirect_url) || page_path(conn, :index)
        conn = delete_session(conn, :redirect_url)

        conn
        |> put_session(:access_token, session.access_token)
        |> put_flash(:info, gettext("Logged in."))
        |> redirect(to: path)

      {"html", {:error, :not_found}} ->
        conn
        |> put_flash(:error, gettext("Email or password incorrect."))
        |> redirect(to: public_session_path(conn, :new))
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> Session.get_session!()
    |> Session.delete_session()

    conn
    |> put_flash(:info, gettext("Logged out!"))
    |> redirect(to: public_session_path(conn, :new))
  end
end
