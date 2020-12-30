defmodule KlausurarchivWeb.PageController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads

  def index(conn, _params) do
    IO.inspect(conn)
    degrees = Uploads.get_degrees_for_select()
    render(conn, "index.html", degrees: degrees)
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end
end
