defmodule KlausurarchivWeb.LectureController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads

  def index(conn, _params) do
    lectures = Uploads.get_lectures()

    render(conn, "index.html", lectures: lectures)
  end

  def show(conn, %{"id" => lecture_id}) do
    IO.inspect(lecture_id)
    lecture = lecture_id
    |> Uploads.get_lecture()
    |> Klausurarchiv.Repo.preload([exams: [:term]])

    render(conn, "show.html", lecture: lecture)
  end
end
