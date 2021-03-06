defmodule KlausurarchivWeb.PageController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads

  def index(conn, _params) do
    degrees = Uploads.get_degrees_for_select()
    render(conn, "index.html", degrees: degrees)
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end

  def legal(conn, _params) do
    render(conn, "legal.html")
  end
end
