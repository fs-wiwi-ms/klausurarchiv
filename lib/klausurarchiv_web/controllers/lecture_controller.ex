defmodule KlausurarchivWeb.LectureController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Uploads
  alias Klausurarchiv.Uploads.Lecture
  alias Klausurarchiv.Users

  def shortcuts(conn, %{"id" => lecture_id}) do
    user =
      conn
      |> get_session(:user_id)
      |> Users.get_user()

    lecture =
      lecture_id
      |> Uploads.get_lecture([:shortcuts, :degrees])

    live_render(conn, KlausurarchivWeb.ShortcutLive,
      session: %{"user" => user, "lecture" => lecture}
    )
  end

  def shortcuts(conn, _params) do
    user =
      conn
      |> get_session(:user_id)
      |> Users.get_user()

    live_render(conn, KlausurarchivWeb.ShortcutLive, session: %{"user" => user})
  end

  def show(conn, %{"id" => lecture_id}) do
    user =
      conn
      |> get_session(:user_id)
      |> Users.get_user()

    lecture =
      lecture_id
      |> Uploads.get_lecture([:shortcuts, :degrees])

    case lecture do
      nil ->
        conn
        |> put_layout(false)
        |> put_status(:internal_server_error)
        |> render(KlausurarchivWeb.ErrorView, :"500")
        |> halt()

      _ ->
        if lecture.published or (not is_nil(user) and user.role == :admin) do
          exams =
            lecture.id
            |> Uploads.get_exams_for_lecture(user)

          lecture_changeset = Uploads.change_lecture(lecture, %{})

          render(conn, "show.html",
            lecture: lecture,
            exams: exams,
            changeset: lecture_changeset,
            action: lecture_path(conn, :update, lecture_id)
          )
        else
          conn
          |> put_layout(false)
          |> put_status(:unauthorized)
          |> render(KlausurarchivWeb.ErrorView, :"401")
          |> halt()
        end
    end
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

  def publish(conn, %{"id" => lecture_id}) do
    lecture = Uploads.get_lecture(lecture_id, [:degrees, :shortcuts])
    Uploads.update_lecture(lecture, %{"published" => true})

    conn
    |> put_flash(:info, "Published")
    |> redirect(to: lecture_path(conn, :show, lecture.id))
  end

  def archive(conn, %{"id" => lecture_id}) do
    lecture = Uploads.get_lecture(lecture_id, [:degrees, :shortcuts])
    Uploads.update_lecture(lecture, %{"published" => false})

    conn
    |> put_flash(:info, "Archived")
    |> redirect(to: lecture_path(conn, :show, lecture.id))
  end
end
