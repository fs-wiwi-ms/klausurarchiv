defmodule KlausurarchivWeb.Authentification do
  alias Plug.Conn

  def auth_user(conn, username, password) do
    with username == System.get_env("USERNAME"),
         password == System.get_env("PASSWORD") do
      conn
    else
      _ ->
        Conn.halt(conn)
    end
  end
end
