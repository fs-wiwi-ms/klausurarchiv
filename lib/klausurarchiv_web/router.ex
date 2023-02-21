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
      type: :browser,
      forward_to_login: false
    )
  end

  pipeline :protected_browser do
    plug(KlausurarchivWeb.Authentication,
      type: :browser,
      forward_to_login: true
    )
  end

  pipeline :confirmed_email do
    plug(KlausurarchivWeb.Authentication,
      type: :browser,
      forward_to_login: true
    )

    plug(KlausurarchivWeb.ConfirmedEmail)
  end

  pipeline :admins_only do
    plug(KlausurarchivWeb.Authentication,
      type: :browser,
      forward_to_login: true
    )

    plug(KlausurarchivWeb.AdminOnly)
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

    resources("/exams", ExamController, only: [:edit, :update, :delete])

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

    resources("/sessions", SessionController, only: [:delete])

    get(
      "/account_confirmations/not_confirmed",
      AccountConfirmationController,
      :not_confirmed
    )

    get(
      "/account_confirmations/send_confirmation_mail",
      AccountConfirmationController,
      :send_confirmation_mail
    )

    resources("/exams", ExamController, only: [:new, :create])
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack with user authentification and confirmed email adress
    pipe_through([:unsecure_browser, :protected_browser, :confirmed_email])

    get("/attachments/:id/download", AttachmentController, :download)
    get("/attachments/:id/preview", AttachmentController, :preview)
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

    get(
      "/account_confirmations/confirm_mail/:token",
      AccountConfirmationController,
      :confirm_mail
    )
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack without authentification
    pipe_through([:unsecure_browser, :browser])

    get("/", PageController, :index)
    get("/privacy", PageController, :privacy)
    get("/legal", PageController, :legal)

    resources("/lectures", LectureController, only: [:show])

    resources("/exams", ExamController, only: [:new, :create])
  end

  if Mix.env() == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
