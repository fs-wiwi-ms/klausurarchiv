defmodule KlausurarchivWeb.Router do
  use KlausurarchivWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :protected_browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery, with: :clear_session)
    plug(:put_secure_browser_headers)
    # plug(ImmobookWeb.Authentication, type: :browser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack with user authentification
    pipe_through(:protected_browser)

    get("/", PageController, :index)

    # resources "/degrees", DegreeController, only: []

    resources("/lectures", LectureController, only: [:new, :create])

    resources("/exams", ExamController, only: [:new, :create])
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack without authentification
    pipe_through(:browser)

    get("/", PageController, :index)

    resources("/degrees", DegreeController, only: [:index, :show])

    resources("/lectures", LectureController, only: [:index, :show])

    resources("/exams", ExamController, only: [:index, :show])
  end

  # Other scopes may use custom stacks.
  # scope "/api", KlausurarchivWeb do
  #   pipe_through :api
  # end
end
