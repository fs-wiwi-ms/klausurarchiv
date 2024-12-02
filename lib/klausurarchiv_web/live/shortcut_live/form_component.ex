defmodule KlausurarchivWeb.ShortcutLive.FormComponent do
  use KlausurarchivWeb, :live_component

  alias Klausurarchiv.Uploads

  @impl true
  def update(%{shortcut: shortcut} = assigns, socket) do
    changeset = Uploads.change_shortcut(shortcut)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"shortcut" => shortcut_params}, socket) do
    changeset =
      socket.assigns.shortcut
      |> Uploads.change_shortcut(shortcut_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"shortcut" => shortcut_params}, socket) do
    save_shortcut(socket, socket.assigns.action, shortcut_params)
  end

  defp save_shortcut(socket, :edit, shortcut_params) do
    case Uploads.update_shortcut(socket.assigns.shortcut, shortcut_params) do
      {:ok, _shortcut} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shortcut updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_shortcut(socket, :new, shortcut_params) do
    case Uploads.create_shortcut(shortcut_params) do
      {:ok, _shortcut} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shortcut created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
