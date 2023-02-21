defmodule KlausurarchivWeb.LectureLive do
  use Phoenix.LiveView
  import Appsignal.Phoenix.LiveView, only: [instrument: 4]
  alias Klausurarchiv.{Users, Uploads}

  def mount(_params, %{"filter" => filter, "user" => user}, socket) do
    degrees = Uploads.get_degrees_for_select()

    lectures =
      if empty_filter?(filter) do
        []
      else
        Uploads.filter_lectures(filter, user, [:shortcuts])
      end

    instrument(__MODULE__, "mount", socket, fn ->
      {:ok,
       assign(socket,
         lectures: lectures,
         degrees: degrees,
         filter: filter,
         user: user
       )}
    end)
  end

  def render(assigns) do
    KlausurarchivWeb.LectureView.render("_search.html", assigns)
  end

  def handle_event(
        "submit",
        %{"filter" => filter},
        %{assigns: %{user: user}} = socket
      ) do
    lectures =
      if empty_filter?(filter) do
        []
      else
        Uploads.filter_lectures(filter, user, [:shortcuts])
      end

    if not is_nil(user) do
      Users.update_user(user, %{filter_data: filter})
    end

    instrument(__MODULE__, "submit", socket, fn ->
      {:noreply, assign(socket, lectures: lectures, filter: filter)}
    end)
  end

  def terminate(_reason, socket) do
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
