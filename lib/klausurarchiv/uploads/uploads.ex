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

  def get_degrees_for_select() do
    Degree
    |> select([d], {d.name, d.id})
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

  def get_exams_by_lecture(%{id: lecture_id}) do
    from(
      e in Exam,
      join: el in assoc(e, :exams),
      where: el.id == ^lecture_id
    )
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

  def get_lectures(filter) do
    full_text_search =
    degree_id = filter["degree"]
    capital_search = "#{filter["capital"]}%"

    query = Lecture
    |> join(:inner, [l], ld in assoc(l, :degrees))

    query = Enum.reduce(filter, query, fn x, acc -> filter_lectures(acc, x) end) |> IO.inspect()
    # |> where([l, ld], l.name == ^full_text_search)
    # |> or_where([l, ld], l.name == ^capital_search)
    # |> where([l, ld], ld.id == ^degree_id)
    Repo.all(query)
  end

  def filter_lectures(query, {"degree", "all"}) do
    query
  end

  def filter_lectures(query, {"degree", degree_id}) do
    where(query, [l, ld], ld.id == ^degree_id)
  end

  def filter_lectures(query, {"query", ""}), do: query

  def filter_lectures(query, {"query", full_text_search}) do
    where(query, [l, ld], fragment("? ILIKE ?", l.name, ^"%#{full_text_search}%"))
  end

  def filter_lectures(query, {"capital", ""}), do: query

  def filter_lectures(query, {"capital", capital_search}) do
    where(query, [l, ld], fragment("? ILIKE ?", l.name, ^"#{capital_search}%"))
  end


  def get_lectures(filters) do
    Lecture
    |> apply_filters(filters)
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
    degrees = Enum.map(lecture_params["degree_ids"] || [], &get_degree(&1))

    lecture_params =
      lecture_params
      |> Map.drop(["degree_ids"])
      |> Map.put("degrees", degrees)

    %Lecture{}
    |> Repo.preload(:degrees)
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

  def change_lecture(lecture \\ %Lecture{}, attrs \\ %{}) do
    lecture
    |> Lecture.changeset(attrs)
  end

  defp apply_filters(query, filters) do
    Enum.reduce(filters, query, fn filter, acc ->
      where(query, ^filter)
    end)
  end
end
