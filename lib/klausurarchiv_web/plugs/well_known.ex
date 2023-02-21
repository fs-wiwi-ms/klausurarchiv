defmodule KlausurarchivWeb.Plugs.WellKnown do
  import Plug.Conn

  @behaviour Plug

  def init(opts), do: opts

  def call(%Plug.Conn{path_info: [".well-known", route]} = conn, _opts) do
    conn
    |> handle(route)
    |> halt()
  end

  def call(conn, _opts), do: conn

  def handle(conn, "health_check") do
    try do
      Ecto.Adapters.SQL.query(Klausurarchiv.Repo, "SELECT 1", [], log: false)
      send_resp(conn, 200, "ok")
    rescue
      _e in DBConnection.ConnectionError -> send_resp(conn, 500, "")
    end
  end

  def handle(conn, "application_status") do
    Phoenix.Controller.json(conn, %{
      nr_of_processes: Process.list() |> Enum.count()
    })
  end
end
