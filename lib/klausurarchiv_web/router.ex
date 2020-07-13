defmodule KlausurarchivWeb.Router do
  use KlausurarchivWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(PlugPreferredLocales, ignore_area: true)
    plug(:set_language)
  end

  pipeline :protected_browser do
    plug(KlausurarchivWeb.Authentification)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  def set_language(conn, _opts) do
    preferred_languages = MapSet.new(conn.private.plug_preferred_locales)

    available_languages =
      KlausurarchivWeb.Gettext
      |> Gettext.known_locales()
      |> MapSet.new()

    intersection = MapSet.intersection(preferred_languages, available_languages)

    if MapSet.size(intersection) > 0 do
      intersection
      |> MapSet.to_list()
      |> List.first()
      |> Gettext.put_locale()
    end

    conn
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack with user authentification
    pipe_through([:browser, :protected_browser])

    resources("/lectures", LectureController, only: [:new, :create])

    get("/exams/drafts", ExamController, :draft)
    post("/exams/publish/:id", ExamController, :publish)
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack without authentification
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/privacy", PageController, :privacy)

    resources("/exams", ExamController, only: [:new, :create])

    resources("/lectures", LectureController, only: [:index, :show])
  end
end
