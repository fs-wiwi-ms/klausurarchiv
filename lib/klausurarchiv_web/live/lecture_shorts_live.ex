defmodule KlausurarchivWeb.LectureShortcutsLive do
  use Phoenix.LiveView
  alias Klausurarchiv.Uploads

  def mount(_params, %{"lecture_id" => lecture_id}, socket) do
    lecture = Uploads.get_lecture(lecture_id, [:degrees, :shortcuts])

    {:ok, assign(socket, lecture: lecture)}
  end

  def render(assigns) do
    KlausurarchivWeb.LectureView.render("_add_shortcuts.html", assigns)
  end

  def handle_event("submit", %{"lecture" => lecture}, socket) do
    {:ok, lecture} = Uploads.update_lecture(socket.assigns.lecture, lecture)
    {:noreply, assign(socket, lecture: lecture)}
  end
end
