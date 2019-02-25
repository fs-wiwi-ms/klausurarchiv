defmodule KlausurarchivWeb.Router do
  use KlausurarchivWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", KlausurarchivWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)

    resources "/degrees", DegreeController, only: [:index, :show]

    resources("/lectures", LectureController, only: [:index, :show])

    # resources("/exams", ExamController, only: [:new, :create])
  end

  # Other scopes may use custom stacks.
  # scope "/api", KlausurarchivWeb do
  #   pipe_through :api
  # end
end
