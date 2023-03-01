defmodule Klausurarchiv.Uploads do
  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [add_error: 4]
  alias Klausurarchiv.{Repo, Attachment, Email, Users}

  alias Klausurarchiv.Uploads.{
    Term,
    Degree,
    Lecture,
    Exam,
    Shortcut
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

  def get_exams_for_lecture(lecture_id, user) do
    Exam
    |> join(:inner, [e], t in assoc(e, :term))
    |> where([e, t], e.lecture_id == ^lecture_id)
    |> filter_exams_for_user(user)
    |> order_by([e, t], desc: t.year, desc: t.type)
    |> preload([e, t], [:term, :attachment])
    |> Repo.all()
  end

  def filter_exams_for_user(query, %{role: :admin}), do: query

  def filter_exams_for_user(query, _user) do
    where(query, [e, t], e.published == true)
  end

  def get_exam(id, preload \\ []) do
    Exam
    |> Repo.get(id)
    |> Repo.preload(preload)
  end

  defp unplubished_exams_query() do
    Exam
    |> where([e], e.published == false)
  end

  def get_unplubished_exams() do
    unplubished_exams_query()
    |> preload([e], [:lecture, :term, :attachment])
    |> Repo.all()
  end

  def get_unplublished_exams_count() do
    unplubished_exams_query()
    |> select([e], count(e.id))
    |> Repo.one()
  end

  def create_exam(
        %{"file" => file, "term_id" => _term_id, "lecture_id" => _lecture_id} =
          exam_params
      ) do
    {:ok, attachment} =
      Attachment.create_attachment(%{
        "upload" => file
      })

    exam_params =
      exam_params
      |> Map.drop(["file"])
      |> Map.put("attachment", attachment)
      |> Map.put("published", false)

    result =
      %Exam{}
      |> change_exam(exam_params)
      |> Repo.insert()

    if {:ok, exam} = result do
      exam = Repo.preload(exam, [:term, :lecture])

      for user <- Users.get_administrator_users() do
        IO.inspect("Sent mail for new exam to #{user.email}")
        Email.new_exam_uploaded_email(user, exam)
      end
    end

    result
  end

  def create_exam(exam_params) do
    # no file upload contained in params
    changeset =
      %Exam{}
      |> change_exam(exam_params)
      |> add_error(:file, "cannot be empty", [])

    {:error, changeset}
  end

  def update_exam(exam, exam_params) do
    exam
    |> change_exam(exam_params)
    |> Repo.update()
  end

  def change_exam(exam \\ %Exam{}, attrs \\ %{}) do
    exam
    |> Repo.preload([:attachment])
    |> Exam.changeset(attrs)
  end

  def delete_exam(exam) do
    with exam <- Repo.preload(exam, [:attachment]) do
      Repo.delete(exam)
      Attachment.delete_attachment(exam.attachment)
    end
  end

  # -----------------------------------------------------------------
  # -- Lecture
  # -----------------------------------------------------------------

  def get_lectures(preload \\ []) do
    Lecture
    |> preload(^preload)
    |> Repo.all()
  end

  def filter_lectures(filter, user, preload \\ []) do
    query =
      Lecture
      |> join(:inner, [l], ld in assoc(l, :degrees))
      |> join(:left, [l, d], s in assoc(l, :shortcuts))

    filter
    |> Enum.reduce(query, fn x, acc -> build_lecture_filter(acc, x) end)
    |> distinct(true)
    |> filter_lectures_for_user(user)
    |> order_by([l, ld], asc: l.name)
    |> preload(^preload)
    |> Repo.all()
  end

  def filter_lectures_for_user(query, %{role: :admin}), do: query

  def filter_lectures_for_user(query, _user) do
    where(query, [l, ld], l.published == true)
  end

  defp build_lecture_filter(query, {"degree", "all"}) do
    query
  end

  defp build_lecture_filter(query, {"degree", degree_id}) do
    where(query, [l, ld, s], ld.id == ^degree_id)
  end

  defp build_lecture_filter(query, {"query", ""}), do: query

  defp build_lecture_filter(query, {"query", full_text_search}) do
    query
    |> where(
      [l, ld, s],
      fragment("? ILIKE ?", l.name, ^"%#{full_text_search}%")
    )
    |> or_where(
      [l, ld, s],
      fragment("? ILIKE ?", s.name, ^"%#{full_text_search}%")
    )
    |> or_where(
      [l, ld, s],
      fragment("? ILIKE ?", l.module_number, ^"%#{full_text_search}%")
    )
  end

  defp build_lecture_filter(query, {"capital", ""}), do: query

  defp build_lecture_filter(query, {"capital", capital_search}) do
    where(
      query,
      [l, ld, s],
      fragment("? ILIKE ?", l.name, ^"#{capital_search}%")
    )
  end

  def get_lectures_by_degree(%{id: degree_id}) do
    from(
      l in Lecture,
      join: ld in assoc(l, :degrees),
      where: ld.id == ^degree_id
    )
    |> Repo.all()
  end

  def get_lecture(id, preload \\ []) do
    case Ecto.UUID.dump(id) do
      {:ok, _uuid} ->
        Lecture
        |> Repo.get(id)

      :error ->
        IO.inspect("slug " <> id)

        Lecture
        |> Repo.get_by(slug: id)
    end
    |> Repo.preload(preload)
  end

  def create_lecture(lecture_params) do
    degrees = Enum.map(lecture_params["degree_ids"] || [], &get_degree(&1))

    lecture_params =
      lecture_params
      |> Map.drop(["degree_ids"])
      |> Map.put("degrees", degrees)
      |> Map.put("shortcuts", [])

    %Lecture{}
    |> Repo.preload(:degrees)
    |> Lecture.changeset(lecture_params)
    |> Repo.insert()
  end

  def update_lecture(lecture, lecture_params) do
    shortcuts =
      if lecture_params["shortcuts"] do
        lecture_params["shortcuts"]
        |> String.split(",")
        |> Enum.filter(fn string -> not is_nil(string) && string != "" end)
        |> Enum.map(&%{name: &1, published: nil})
      else
        []
      end

    shortcuts =
      lecture.shortcuts
      |> Enum.concat(shortcuts)
      |> Enum.uniq_by(fn %{name: short} -> String.downcase(short) end)

    degrees =
      Enum.map(
        lecture_params["degree_ids"] || Enum.map(lecture.degrees, & &1.id),
        &get_degree(&1)
      )

    lecture_params =
      lecture_params
      |> Map.drop(["degree_ids"])
      |> Map.drop(["shortcuts"])
      |> Map.put("degrees", degrees)
      |> Map.put("shortcuts", shortcuts)

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

  # -----------------------------------------------------------------
  # -- Shortcuts
  # -----------------------------------------------------------------

  def get_shortcut(id, preload \\ []) do
    Shortcut
    |> Repo.get(id)
    |> Repo.preload(preload)
  end

  def get_unplublished_shortcuts_count() do
    Shortcut
    |> where([s], is_nil(s.published))
    |> select([s], count(s.id))
    |> Repo.one()
  end

  def update_shortcut_state(shortcut_id, state) do
    short = get_shortcut(shortcut_id, [:lecture])

    short
    |> Shortcut.changeset(%{"published" => state})
    |> Repo.update()
  end
end
