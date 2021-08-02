defmodule KlausurarchivWeb.AttachmentController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Attachment

  def download(conn, %{"id" => id}) do
    with %{id: _id} = attachment <- Attachment.get_attachment(id),
         {:ok, url} <- Attachment.presigned_attachment_url(attachment) do
      conn
      |> redirect(external: url)
    else
      {:error, _} ->
        send_resp(conn, 404, "not found")

      nil ->
        send_resp(conn, 404, "not found")
    end
  end
end
