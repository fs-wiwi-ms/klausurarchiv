defmodule KlausurarchivWeb.ShortcutLive.Show do
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
     |> assign(:shortcut, Uploads.get_shortcut!(id))}
  end

  defp page_title(:show), do: "Show Shortcut"
  defp page_title(:edit), do: "Edit Shortcut"
end
