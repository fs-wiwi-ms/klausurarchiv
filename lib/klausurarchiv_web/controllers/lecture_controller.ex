defmodule KlausurarchivWeb.LectureController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads
  alias Klausurarchiv.Uploads.Lecture

  def index(conn, %{"filter" => filter} = params) do
    lectures = Uploads.get_lectures(filter)

    render(conn, "index.html", lectures: lectures)
  end

  def show(conn, %{"id" => lecture_id}) do
    lecture =
      lecture_id
      |> Uploads.get_lecture()
      |> Klausurarchiv.Repo.preload(exams: [:term])

    render(conn, "show.html", lecture: lecture)
  end

  def new(conn, _params) do
    lecture_changeset =
      %Lecture{}
      |> Uploads.change_lecture(%{})

    degrees = Uploads.get_degrees()

    render(conn, "new.html",
      changeset: lecture_changeset,
      degrees: degrees,
      action: lecture_path(conn, :create)
    )
  end

  def create(conn, %{"lecture" => lecture}) do
    case Uploads.create_lecture(lecture) do
      {:ok, lecture} ->
        lecture = Klausurarchiv.Repo.preload(lecture, exams: [:term])

        conn
        |> put_flash(:info, "Erstellt")
        |> redirect(to: lecture_path(conn, :show, lecture.id))

      {:error, changeset} ->
        degrees = Uploads.get_degrees()

        conn
        |> put_flash(:error, "Fehler beim Erstellen")
        |> render("new.html",
          changeset: changeset,
          degrees: degrees,
          action: lecture_path(conn, :create)
        )
    end
  end
end
