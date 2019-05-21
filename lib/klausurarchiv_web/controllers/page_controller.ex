defmodule KlausurarchivWeb.PageController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads

  def index(conn, _params) do
    degrees = Uploads.get_degrees_for_select()
    render(conn, "index.html", degrees: degrees)
  end
end
