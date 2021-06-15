defmodule KlausurarchivWeb.ShortcutLive do
  use Phoenix.LiveView
  import Appsignal.Phoenix.LiveView, only: [instrument: 4]
  alias Klausurarchiv.Uploads

  def mount(_params, %{"user" => user}, socket) do
    lectures = Uploads.get_lectures([:shortcuts])

    instrument(__MODULE__, "mount", socket, fn ->
      {:ok, assign(socket, lectures: lectures, user: user)}
    end)
  end

  def render(assigns) do
    KlausurarchivWeb.LectureView.render("shortcuts.html", assigns)
  end

  def handle_event(
        "approve",
        %{"short_id" => short_id},
        socket
      ) do
    Uploads.update_shortcut_state(short_id, true)
    lectures = Uploads.get_lectures([:shortcuts])

    instrument(__MODULE__, "approve", socket, fn ->
      {:noreply, assign(socket, lectures: lectures)}
    end)
  end

  def handle_event(
        "reject",
        %{"short_id" => short_id},
        socket
      ) do
    Uploads.update_shortcut_state(short_id, false)
    lectures = Uploads.get_lectures([:shortcuts])

    instrument(__MODULE__, "reject", socket, fn ->
      {:noreply, assign(socket, lectures: lectures)}
    end)
  end
end
