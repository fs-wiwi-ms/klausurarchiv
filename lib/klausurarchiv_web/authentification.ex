# defmodule KlausurarchivWeb.Authentication do
#   import Plug.Conn

#   @doc false
#   def init(opts), do: opts

#   @doc false
#   def call(conn, type: :browser) do
#     access_token = get_session(conn, :access_token)
#     refresh_token = conn.cookies["refresh_token"]

#     case Accounts.verify_session(access_token, refresh_token) do
#       {:ok, %{refresh_token: nil} = session} ->
#         conn
#         |> put_session(:access_token, session.access_token)
#         |> assign(:session, session)

#       {:ok, session} ->
#         conn
#         |> put_session(:access_token, session.access_token)
#         |> put_resp_cookie("refresh_token", session.refresh_token)
#         |> assign(:session, session)

#       {:error, _} ->
#         conn
#         |> put_session(:redirect_url, conn.request_path)
#         |> put_flash(:info, gettext("request_log_in"))
#         |> redirect(
#           to: ImmobookWeb.Router.Helpers.public_session_path(conn, :new)
#         )
#         |> halt()
#     end
#   end
# end
