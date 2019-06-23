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
    plug(BasicAuth, use_config: {:klausurarchiv, :http_auth})
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack with user authentification
    pipe_through(:protected_browser)

    resources("/lectures", LectureController, only: [:new, :create])

    get("/exams/drafts", ExamController, :draft)
    post("/exams/publish/:id", ExamController, :publish)
  end

  scope "/", KlausurarchivWeb do
    # Use the browser stack without authentification
    pipe_through(:browser)

    get("/", PageController, :index)

    resources("/exams", ExamController, only: [:new, :create])

    resources("/degrees", DegreeController, only: [:index, :show])

    resources("/lectures", LectureController, only: [:index, :show])
  end
end
