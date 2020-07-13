defmodule KlausurarchivWeb.Authentification do
  import Plug.Conn

  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         true <- user == System.get_env("USERNAME"),
         true <- pass == System.get_env("PASSWORD") do
        conn
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end
end
