defmodule KlausurarchivWeb.Authentication do
  @moduledoc "Plug-compliant functions to authenticate requests"

  alias Klausurarchiv.Users.Session
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, type: :browser, forward_to_login: forward_to_login) do
    access_token = get_session(conn, :access_token) || ""
    refresh_token = conn.cookies["refresh_token"] || ""

    case Session.verify_session(access_token, refresh_token) do
      {:ok, %{refresh_token: nil} = session} ->
        conn
        |> put_session(:access_token, session.access_token)
        |> put_session(:user_id, session.user_id)
        |> assign(:session, session)

      {:ok, session} ->
        conn
        |> put_session(:access_token, session.access_token)
        |> put_session(:user_id, session.user_id)
        |> put_resp_cookie("refresh_token", session.refresh_token)
        |> assign(:session, session)

      {:error, _} ->
        if forward_to_login do
          conn
          |> put_session(:redirect_url, conn.request_path)
          |> put_flash(:info, "Please login to continue.")
          |> redirect(
            to: KlausurarchivWeb.Router.Helpers.public_session_path(conn, :new)
          )
          |> halt()
        else
          conn
        end
    end
  end
end
