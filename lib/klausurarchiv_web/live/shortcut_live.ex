defmodule KlausurarchivWeb.ShortcutLive do
  use Phoenix.LiveView
  alias Klausurarchiv.Uploads

  def mount(_params, session, socket) do
    lectures = Uploads.get_lectures([:shortcuts])
    {:ok, assign(socket, lectures: lectures)}
  end

  def render(assigns) do
    KlausurarchivWeb.LectureView.render("shortcuts.html", assigns)
  end

  def handle_event("approve", %{"lecture_id" => lecture_id, "short_id" => short_id}, socket) do
    Uploads.update_shortcut_state(short_id, true)
    lectures = Uploads.get_lectures([:shortcuts])
    {:noreply, assign(socket, lectures: lectures)}
  end

  def handle_event("reject", %{"lecture_id" => lecture_id, "short_id" => short_id}, socket) do
    Uploads.update_shortcut_state(short_id, false)
    lectures = Uploads.get_lectures([:shortcuts])
    {:noreply, assign(socket, lectures: lectures)}
  end
end
