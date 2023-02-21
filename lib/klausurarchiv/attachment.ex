defmodule Klausurarchiv.Attachment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Klausurarchiv.{Repo, Attachment}

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "attachments" do
    field(:file_name)
    field(:location)
    field(:size, :integer)
    field(:content_type)

    field(:upload, :any, virtual: true)

    timestamps()
  end

  @doc false
  defp changeset(attachment, params) do
    attachment
    |> cast(params, [
      :upload
    ])
    |> maybe_parse_attachment()
    |> validate_required([
      :file_name,
      :content_type,
      :size
    ])
    |> maybe_generate_id()
    |> maybe_upload()
  end

  @doc "Returns a presigned URL, which allows to download the attachment"
  def presigned_attachment_url(
        %{location: location, file_name: file_name},
        content_disposition \\ "attachment"
      ) do
    options = ExAws.Config.new(:s3)

    options =
      if options[:host] == "minio" do
        Map.put(options, :host, "localhost")
      else
        options
      end

    # use inline instead of attachment to preview
    query_params = [
      {"response-content-type", "application/pdf"},
      {"response-content-disposition",
       ~s(#{content_disposition}; filename="#{file_name}")}
    ]

    ExAws.S3.presigned_url(options, :get, bucket(), location,
      expires_in: 10,
      query_params: query_params
    )
  end

  defp delete(%{location: location}), do: delete(location)

  defp delete(location) do
    # delete attachment from AWS S3 bucket"
    bucket()
    |> ExAws.S3.delete_object(location)
    |> ExAws.request!()
  end

  defp maybe_parse_attachment(
         %{data: %{__meta__: %{state: :loaded}}, changes: %{upload: _}} =
           changeset
       ),
       do: parse_attachment(changeset)

  defp maybe_parse_attachment(
         %{data: %{__meta__: %{state: :built}}, changes: %{upload: _}} =
           changeset
       ),
       do: parse_attachment(changeset)

  defp maybe_parse_attachment(changeset), do: changeset

  defp parse_attachment(changeset) do
    attachment = get_field(changeset, :upload)

    with true <- File.exists?(attachment.path),
         {:ok, %{size: size}} <- File.stat(attachment.path) do
      changeset
      |> put_change(:content_type, attachment.content_type)
      |> put_change(:file_name, attachment.filename)
      |> put_change(:size, size)
    else
      _other ->
        add_error(changeset, :upload, "not valid")
    end
  end

  defp maybe_generate_id(%{data: %{__meta__: %{state: :built}}} = changeset) do
    put_change(changeset, :id, Ecto.UUID.generate())
  end

  defp maybe_generate_id(changeset), do: changeset

  defp maybe_upload(%{data: %{__meta__: %{state: :built}}} = changeset),
    do: upload_attachment(changeset)

  defp maybe_upload(
         %{data: %{__meta__: %{state: :loaded}}, changes: %{upload: _}} =
           changeset
       ) do
    delete(changeset.data.location)
    upload_attachment(changeset)
  end

  defp maybe_upload(changeset), do: changeset

  defp upload_attachment(%{changes: %{upload: _}} = changeset) do
    src_path = get_field(changeset, :upload).path
    content_type = get_field(changeset, :upload).content_type

    dest_path =
      changeset
      |> get_field(:id)
      |> generate_path()

    bucket()
    |> ExAws.S3.put_object(dest_path, File.read!(src_path),
      content_type: content_type
    )
    |> ExAws.request!()

    put_change(changeset, :location, dest_path)
  end

  defp upload_attachment(changeset), do: changeset

  defp generate_path(id) do
    String.replace(id, "-", "/")
  end

  defp bucket do
    System.get_env("S3_BUCKET")
  end

  # ---------------------------------------------------------------------------------
  # -------- Files
  # ---------------------------------------------------------------------------------

  @doc "get an attachment by given id"
  def get_attachment(id) do
    Repo.get(Attachment, id)
  end

  @doc "create an attachment changeset"
  def change_attachment(attachment \\ %Attachment{}, data \\ %{}) do
    attachment
    |> changeset(data)
  end

  @doc "delete attachment"
  def delete_attachment(attachment) do
    with result <- Repo.delete(attachment),
         delete(attachment) do
      result
    end
  end

  @doc "creates an attachment"
  def create_attachment(attachment_params) do
    %Attachment{}
    |> changeset(attachment_params)
    |> Repo.insert()
  end

  @doc "creates an attachment"
  def create_attachment(user, attachment_params) do
    attachment_params =
      attachment_params
      |> Map.put("uploader_id", user.id)

    %Attachment{}
    |> changeset(attachment_params)
    |> Repo.insert()
  end

  @doc "Updates an attachment"
  def update_attachment(attachment, attachment_params) do
    changeset = changeset(attachment, attachment_params)

    Repo.update(changeset)
  end
end
