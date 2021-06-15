defmodule KlausurarchivWeb.LectureShortcutsLive do
  use Phoenix.LiveView
  import Appsignal.Phoenix.LiveView, only: [instrument: 4]
  alias Klausurarchiv.Uploads

  def mount(_params, %{"lecture_id" => lecture_id}, socket) do
    lecture = Uploads.get_lecture(lecture_id, [:degrees, :shortcuts])

    instrument(__MODULE__, "mount", socket, fn ->
      {:ok, assign(socket, lecture: lecture)}
    end)
  end

  def render(assigns) do
    KlausurarchivWeb.LectureView.render("_add_shortcuts.html", assigns)
  end

  def handle_event("submit", %{"lecture" => lecture}, socket) do
    {:ok, lecture} = Uploads.update_lecture(socket.assigns.lecture, lecture)

    instrument(__MODULE__, "submit", socket, fn ->
      {:noreply, assign(socket, lecture: lecture)}
    end)
  end
end
