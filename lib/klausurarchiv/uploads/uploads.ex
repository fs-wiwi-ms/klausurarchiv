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

  def get_term_by_year_and_type(year, type) do
    Term
    |> Repo.get_by(type: type, year: year)
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

  def get_published_exams_for_lecture(lecture_id) do
    from(
      e in Exam,
      join: t in assoc(e, :term),
      where: e.lecture_id == ^lecture_id,
      where: e.published == true,
      order_by: [desc: t.year, desc: t.type],
      preload: [:term]
    )
    |> Repo.all()
  end

  def get_exam(id) do
    Exam
    |> Repo.get(id)
  end

  def get_unplubished_exams() do
    from(
      e in Exam,
      where: e.published == false,
      preload: [:lecture, :term]
    )
    |> Repo.all()
  end

  def create_exam(exam_params) do
    {file_args, exam_params} = Map.pop(exam_params, "file")
    {term_args, exam_params} = Map.pop(exam_params, "term")
    {lecture_id, exam_params} = Map.pop(exam_params, "lecture_id")

    term = get_term_by_year_and_type(term_args["year"], term_args["type"])
    lecture = get_lecture(lecture_id)

    case upload_file(term, lecture, file_args) do
      {:ok, filename} ->
        exam_params =
          exam_params
          |> Map.put("lecture_id", lecture.id)
          |> Map.put("term_id", term.id)
          |> Map.put("filename", filename)
          |> Map.put("published", false)

        %Exam{}
        |> Exam.changeset(exam_params)
        |> Repo.insert()

      {:error, _error} ->
        {:error, "file could not be uploaded"}
    end
  end

  def update_exam(exam, exam_params) do
    exam
    |> Exam.changeset(exam_params)
    |> Repo.update()
  end

  def change_exam(exam \\ %Exam{}, attrs \\ %{}) do
    exam
    |> Exam.changeset(attrs)
  end

  def delete_exam(exam) do
    Repo.delete(exam)
  end

  # -----------------------------------------------------------------
  # -- Exam - File Uploader
  # -----------------------------------------------------------------

  @url "https://fsk.uni-muenster.de/"

  defp upload_file(term, lecture, file) do
    HTTPoison.start()

    url = @url <> "klausuren/klausur_receiver.php"

    form = [
      {"jahr", "#{term.year}"},
      {"semester", "#{term.type}"},
      {"vorlesung", "#{lecture.name}"},
      {"upload", "klausurupload"},
      {:file, file.path}
    ]

    case HTTPoison.post(url, {:multipart, form}) do
      {:ok, response} ->
        {:ok, response.body}

      {:error, exception} ->
        {:error, HTTPoison.Error.message(exception)}
    end
  end

  # -----------------------------------------------------------------
  # -- Lecture
  # -----------------------------------------------------------------

  def get_lectures() do
    Lecture
    |> Repo.all()
  end

  def get_lectures(filter) do
    query =
      Lecture
      |> join(:inner, [l], ld in assoc(l, :degrees))

    filter
    |> Enum.reduce(query, fn x, acc -> filter_lectures(acc, x) end)
    |> distinct(true)
    |> order_by([l, ld], asc: l.name)
    |> Repo.all()
  end

  defp filter_lectures(query, {"degree", "all"}) do
    query
  end

  defp filter_lectures(query, {"degree", degree_id}) do
    where(query, [l, ld], ld.id == ^degree_id)
  end

  defp filter_lectures(query, {"query", ""}), do: query

  defp filter_lectures(query, {"query", full_text_search}) do
    where(
      query,
      [l, ld],
      fragment("? ILIKE ?", l.name, ^"%#{full_text_search}%")
    )
  end

  defp filter_lectures(query, {"capital", ""}), do: query

  defp filter_lectures(query, {"capital", capital_search}) do
    where(query, [l, ld], fragment("? ILIKE ?", l.name, ^"#{capital_search}%"))
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
end
