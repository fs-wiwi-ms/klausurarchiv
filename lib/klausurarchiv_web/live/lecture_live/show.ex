defmodule KlausurarchivWeb.LectureLive.Show do
  use KlausurarchivWeb, :live_view

  alias Klausurarchiv.Uploads

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:lecture, Uploads.get_lecture!(id))}
  end

  defp page_title(:show), do: "Show Lecture"
  defp page_title(:edit), do: "Edit Lecture"
end
