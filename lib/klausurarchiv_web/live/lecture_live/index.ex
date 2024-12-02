defmodule KlausurarchivWeb.LectureLive.Index do
  use KlausurarchivWeb, :live_view

  alias Klausurarchiv.Uploads
  alias Klausurarchiv.Uploads.Lecture

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :lecture_collection, list_lecture())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Lecture")
    |> assign(:lecture, Uploads.get_lecture!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Lecture")
    |> assign(:lecture, %Lecture{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lecture")
    |> assign(:lecture, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    lecture = Uploads.get_lecture!(id)
    {:ok, _} = Uploads.delete_lecture(lecture)

    {:noreply, assign(socket, :lecture_collection, list_lecture())}
  end

  defp list_lecture do
    Uploads.list_lecture()
  end
end
