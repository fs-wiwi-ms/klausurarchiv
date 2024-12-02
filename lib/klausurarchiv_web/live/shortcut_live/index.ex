defmodule KlausurarchivWeb.ShortcutLive.Index do
  use KlausurarchivWeb, :live_view

  alias Klausurarchiv.Uploads
  alias Klausurarchiv.Uploads.Shortcut

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :shortcut_collection, list_shortcut())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Shortcut")
    |> assign(:shortcut, Uploads.get_shortcut!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Shortcut")
    |> assign(:shortcut, %Shortcut{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Shortcut")
    |> assign(:shortcut, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    shortcut = Uploads.get_shortcut!(id)
    {:ok, _} = Uploads.delete_shortcut(shortcut)

    {:noreply, assign(socket, :shortcut_collection, list_shortcut())}
  end

  defp list_shortcut do
    Uploads.list_shortcut()
  end
end
