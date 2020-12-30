defmodule KlausurarchivWeb.LectureLive do
  use Phoenix.LiveView
  alias Klausurarchiv.Uploads

  def mount(_params, %{"filter" => filter, "user" => user}, socket) do
    degrees = Uploads.get_degrees_for_select()

    lectures = if empty_filter?(filter) do
      []
    else
      Uploads.filter_lectures(filter, [:shortcuts])
    end

    {:ok, assign(socket, lectures: lectures, degrees: degrees, filter: filter, user: user)}
  end

  def render(assigns) do
    KlausurarchivWeb.LectureView.render("_search.html", assigns)
  end

  def handle_event("submit", %{"filter" => filter}, socket) do
    lectures = if empty_filter?(filter) do
      []
    else
      Uploads.filter_lectures(filter, [:shortcuts])
    end

    {:noreply, assign(socket, lectures: lectures, filter: filter)}
  end

  def terminate(reason, socket) do
    {:noreply, socket}
  end

  defp empty_filter?(filter) when filter == %{}, do: true
  defp empty_filter?(filter) do
    if filter["query"] == "" && filter["degree"] == "all" do
      true
    else
      false
    end
  end
end
