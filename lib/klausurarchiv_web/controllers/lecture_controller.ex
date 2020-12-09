defmodule KlausurarchivWeb.LectureController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads
  alias Klausurarchiv.Uploads.Lecture

  def index(conn, %{"filter" => filter}) do
    live_render(conn, KlausurarchivWeb.LectureLive,
      session: %{
        "filter" => filter
      }
    )
  end

  def index(conn, _params), do: index(conn, %{"filter" => %{}})

  def shortcuts(conn, _params) do
    live_render(conn, KlausurarchivWeb.ShortcutLive)
  end

  def show(conn, %{"id" => lecture_id}) do
    lecture =
      lecture_id
      |> Uploads.get_lecture([:shortcuts, :degrees])

    exams =
      lecture_id
      |> Uploads.get_published_exams_for_lecture()

    lecture_changeset = Uploads.change_lecture(lecture, %{})

    render(conn, "show.html",
      lecture: lecture,
      exams: exams,
      changeset: lecture_changeset,
      action: lecture_path(conn, :update, lecture_id)
    )
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

  def edit(conn, %{"id" => lecture_id}) do
    lecture = Uploads.get_lecture(lecture_id, [:degrees, :shortcuts])

    lecture_changeset = Uploads.change_lecture(lecture, %{})

    degrees = Uploads.get_degrees()

    render(conn, "edit.html",
      changeset: lecture_changeset,
      degrees: degrees,
      lecture: lecture,
      action: lecture_path(conn, :update, lecture_id)
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

  def update(conn, %{"id" => lecture_id, "lecture" => lecture_params}) do
    lecture = Uploads.get_lecture(lecture_id, [:degrees, :shortcuts])

    case Uploads.update_lecture(lecture, lecture_params) do
      {:ok, lecture} ->
        lecture = Klausurarchiv.Repo.preload(lecture, exams: [:term])

        conn
        |> put_flash(:info, "Updated")
        |> redirect(to: lecture_path(conn, :show, lecture.id))
      {:error, changeset} ->
        degrees = Uploads.get_degrees()

        conn
        |> put_flash(:error, "Fehler beim Erstellen")
        |> render("edit.html",
          changeset: changeset,
          degrees: degrees,
          lecture: lecture,
          action: lecture_path(conn, :update, lecture_id)
        )
    end
  end
end
