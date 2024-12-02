defmodule KlausurarchivWeb.LectureLive.FormComponent do
  use KlausurarchivWeb, :live_component

  alias Klausurarchiv.Uploads

  @impl true
  def update(%{lecture: lecture} = assigns, socket) do
    changeset = Uploads.change_lecture(lecture)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"lecture" => lecture_params}, socket) do
    changeset =
      socket.assigns.lecture
      |> Uploads.change_lecture(lecture_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"lecture" => lecture_params}, socket) do
    save_lecture(socket, socket.assigns.action, lecture_params)
  end

  defp save_lecture(socket, :edit, lecture_params) do
    case Uploads.update_lecture(socket.assigns.lecture, lecture_params) do
      {:ok, _lecture} ->
        {:noreply,
         socket
         |> put_flash(:info, "Lecture updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_lecture(socket, :new, lecture_params) do
    case Uploads.create_lecture(lecture_params) do
      {:ok, _lecture} ->
        {:noreply,
         socket
         |> put_flash(:info, "Lecture created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
