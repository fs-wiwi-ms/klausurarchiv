defmodule KlausurarchivWeb.DegreeController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads

  def index(conn, _params) do
    degrees = Uploads.get_degrees()

    render(conn, "index.html", degrees: degrees)
  end

  def show(conn, %{"id" => degree_id}) do
    IO.inspect(degree_id)
    degree = Uploads.get_degree(degree_id)

    lectures = Uploads.get_lectures_by_degree(degree)

    render(conn, "show.html", lectures: lectures)
  end
end
