defmodule Klausurarchiv.Uploads do
  import Ecto.Query, warn: false
  alias Klausurarchiv.Repo

  alias Klausurarchiv.Uploads.{
    Term,
    Degree,
    Lecture,
    Exam
  }

  require Logger

  # -----------------------------------------------------------------
  # -- Term
  # -----------------------------------------------------------------

  def get_terms() do
    Term
    |> Repo.all()
  end

  def get_term(id) do
    Term
    |> Repo.get(id)
  end

  def create_term(term_params) do
    %Term{}
    |> Term.changeset(term_params)
    |> Repo.insert()
  end

  def update_term(term, term_params) do
    term
    |> Term.changeset(term_params)
    |> Repo.update()
  end

  def delete_term(term) do
    Repo.delete(term)
  end

  # -----------------------------------------------------------------
  # -- Degree
  # -----------------------------------------------------------------

  def get_degrees() do
    Degree
    |> Repo.all()
  end

  def get_degree(id) do
    Degree
    |> Repo.get(id)
  end

  def create_degree(degree_params) do
    %Degree{}
    |> Degree.changeset(degree_params)
    |> Repo.insert()
  end

  def update_degree(degree, degree_params) do
    degree
    |> Degree.changeset(degree_params)
    |> Repo.update()
  end

  def delete_degree(degree) do
    Repo.delete(degree)
  end

  # -----------------------------------------------------------------
  # -- Exam
  # -----------------------------------------------------------------

  def get_exams() do
    Exam
    |> Repo.all()
  end

  def create_exam(exam_params) do
    %Exam{}
    |> Exam.changeset(exam_params)
    |> Repo.insert()
  end

  def update_exam(exam, exam_params) do
    exam
    |> Exam.changeset(exam_params)
    |> Repo.update()
  end

  def delete_exam(exam) do
    Repo.delete(exam)
  end

  # -----------------------------------------------------------------
  # -- Lecture
  # -----------------------------------------------------------------

  def get_lectures() do
    Lecture
    |> Repo.all()
  end

  def get_lectures_by_degree(%{id: degree_id}) do
    from(
      l in Lecture,
      join: ld in assoc(l, :degrees),
      where: ld.id == ^degree_id
    )
    |> Repo.all()
  end

  def get_lecture(id) do
    Lecture
    |> Repo.get(id)
  end

  def create_lecture(lecture_params) do
    %Lecture{}
    |> Lecture.changeset(lecture_params)
    |> Repo.insert()
  end

  def update_lecture(lecture, lecture_params) do
    lecture
    |> Lecture.changeset(lecture_params)
    |> Repo.update()
  end

  def delete_lecture(lecture) do
    Repo.delete(lecture)
  end
end
