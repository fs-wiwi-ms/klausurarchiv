defmodule KlausurarchivWeb.Router do
  use KlausurarchivWeb, :router

  pipeline :unsecure_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(PlugPreferredLocales, ignore_area: true)
    plug(:set_language)
  end

  pipeline :browser do
    plug(KlausurarchivWeb.Authentication,
      type: :api_or_browser,
      forward_to_login: false
    )
  end

  pipeline :protected_browser do
    plug(KlausurarchivWeb.Authentication,
      type: :api_or_browser,
      forward_to_login: true
    )
  end

  pipeline :admins_only do
    plug(KlausurarchivWeb.Authentication,
      type: :api_or_browser,
      forward_to_login: true
    )

    plug(KlausurarchivWeb.AdminOnly)
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
    pipe_through([:unsecure_browser, :admins_only])

    resources("/lectures", LectureController,
      only: [:new, :create, :edit, :update]
    )

    resources("/exams", ExamController, only: [:edit, :update])

    get("/exams/drafts", ExamController, :draft)
    get("/exams/:id/publish", ExamController, :publish)
    get("/exams/:id/archive", ExamController, :archive)

    get("/lectures/shortcuts", LectureController, :shortcuts)
    get("/lectures/:id/shortcuts", LectureController, :shortcuts)
    get("/lectures/:id/publish", LectureController, :publish)
    get("/lectures/:id/archive", LectureController, :archive)
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack with user authentification
    pipe_through([:unsecure_browser, :protected_browser])

    resources "/sessions", SessionController, only: [:delete]
  end

  scope "/public", KlausurarchivWeb, as: :public do
    # Use the browser stack without authentification
    pipe_through([:unsecure_browser, :browser])

    resources("/users", UserController, only: [:new, :create])
    resources("/sessions", SessionController, only: [:new, :create])

    resources(
      "/password_reset_tokens",
      PasswordResetTokenController,
      only: [:new, :create, :show, :update]
    )
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack without authentification
    pipe_through([:unsecure_browser, :browser])

    get("/", PageController, :index)
    get("/privacy", PageController, :privacy)
    get("/legal", PageController, :legal)

    resources("/exams", ExamController, only: [:new, :create])

    resources("/lectures", LectureController, only: [:show])

    get("/attachments/:id/download", AttachmentController, :download)
    get("/attachments/:id/preview", AttachmentController, :preview)
  end
end
