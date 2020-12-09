defmodule KlausurarchivWeb.LectureLive do
  use Phoenix.LiveView
  alias Klausurarchiv.Uploads

  def mount(_params, %{"filter" => filter}, socket) do
    lectures = Uploads.filter_lectures(filter, [:shortcuts])
    degrees = Uploads.get_degrees_for_select()
    {:ok, assign(socket, lectures: lectures, degrees: degrees, filter: filter)}
  end

  def render(assigns) do
    KlausurarchivWeb.LectureView.render("index.html", assigns)
  end

  def handle_event("full_text", %{"filter" => filter}, socket) do
    lectures = Uploads.filter_lectures(filter, [:shortcuts])
    {:noreply, assign(socket, lectures: lectures, filter: filter)}
  end
end
