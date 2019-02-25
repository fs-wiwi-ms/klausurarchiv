defmodule KlausurarchivWeb.PageController do
  use KlausurarchivWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
