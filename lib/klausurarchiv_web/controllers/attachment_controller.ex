defmodule KlausurarchivWeb.AttachmentController do
  use KlausurarchivWeb, :controller

  alias Klausurarchiv.Attachment

  def download(conn, attrs) do
    generate_presigned_url(conn, attrs, "attachment")
  end

  def preview(conn, attrs) do
    generate_presigned_url(conn, attrs, "inline")
  end

  defp generate_presigned_url(conn, %{"id" => id}, content_disposition) do
    with %{id: _id} = attachment <- Attachment.get_attachment(id),
         {:ok, url} <-
           Attachment.presigned_attachment_url(attachment, content_disposition) do
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
