defmodule KlausurarchivWeb.ExamController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads

  def new(conn, _params) do
    lectures = Uploads.get_lectures()
    terms = Uploads.get_terms()
    changeset = Uploads.change_exam()

    render(conn, "new.html",
      lectures: lectures,
      terms: terms,
      changeset: changeset,
      action: exam_path(conn, :create)
    )
  end

  def edit(conn, %{"id" => exam_id}) do
    exam = Uploads.get_exam(exam_id, [:term, :lecture])

    exam_changeset = Uploads.change_exam(exam, %{})
    lectures = Uploads.get_lectures()
    terms = Uploads.get_terms()

    render(conn, "edit.html",
      terms: terms,
      lectures: lectures,
      changeset: exam_changeset,
      exam: exam,
      action: exam_path(conn, :update, exam_id)
    )
  end

  def create(conn, %{"exam" => exam}) do
    case Uploads.create_exam(exam) do
      {:ok, _exam} ->
        conn
        |> put_flash(:info, "Erstellt")
        |> redirect(to: page_path(conn, :index))

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
        terms = Uploads.get_terms()

        conn
        |> put_flash(:error, "Fehler beim Erstellen")
        |> render("new.html",
          lectures: lectures,
          terms: terms,
          changeset: changeset,
          action: exam_path(conn, :create)
        )
    end
  end

  def update(conn, %{"id" => exam_id, "exam" => exam_params}) do
    exam = Uploads.get_exam(exam_id, [:term, :lecture])

    case Uploads.update_exam(exam, exam_params) do
      {:ok, exam} ->
        conn
        |> put_flash(:info, "Updated")
        |> redirect(to: lecture_path(conn, :show, exam.lecture_id))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Fehler beim Erstellen")
        |> render("edit.html",
          changeset: changeset,
          exam: exam,
          action: lecture_path(conn, :update, exam_id)
        )
    end
  end

  def publish(conn, %{"id" => exam_id}) do
    exam = Uploads.get_exam(exam_id)
    Uploads.update_exam(exam, %{published: true})

    conn
    |> put_flash(:info, "Published")
    |> redirect(to: lecture_path(conn, :show, exam.lecture_id))
  end

  def archive(conn, %{"id" => exam_id}) do
    exam = Uploads.get_exam(exam_id, [:lecture])
    Uploads.update_exam(exam, %{published: false})

    conn
    |> put_flash(:info, "Archived")
    |> redirect(to: lecture_path(conn, :show, exam.lecture_id))
  end

  def draft(conn, _params) do
    unplubished_exams = Uploads.get_unplubished_exams()

    render(conn, "draft.html", unplubished_exams: unplubished_exams)
  end

  def delete(conn, %{"id" => id}) do
    id
    |> Uploads.get_exam()
    |> Uploads.delete_exam()

    unplubished_exams = Uploads.get_unplubished_exams()

    conn
    |> put_flash(:success, gettext("Deleted!"))
    |> render("draft.html", unplubished_exams: unplubished_exams)
  end
end
