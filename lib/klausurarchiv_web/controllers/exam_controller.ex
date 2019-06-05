defmodule KlausurarchivWeb.ExamController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads

  def new(conn, params) do
    lectures = Uploads.get_lectures()
    changeset = Uploads.change_exam()

    render(conn, "new.html",
      lectures: lectures,
      changeset: changeset,
      action: exam_path(conn, :create)
    )
  end

  def create(conn, %{"exam" => exam}) do
    case Uploads.create_exam(exam) do
      {:ok, exam} ->
        conn
        |> put_flash(:info, "Erstellt")
        |> redirect(to: lecture_path(conn, :show, exam.lecture_id))

      {:error, "file could not be uploaded"} ->
        lectures = Uploads.get_lectures()

        conn
        |> put_flash(:error, "Fehler beim Hochladen")
        |> render("new.html",
          lectures: lectures,
          changeset: Uploads.change_exam(),
          action: exam_path(conn, :create)
        )

      {:error, changeset} ->
        lectures = Uploads.get_lectures()

        conn
        |> put_flash(:error, "Fehler beim Erstellen")
        |> render("new.html",
          lectures: lectures,
          changeset: changeset,
          action: exam_path(conn, :create)
        )
    end
  end
end
