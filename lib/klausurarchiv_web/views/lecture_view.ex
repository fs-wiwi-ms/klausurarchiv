defmodule KlausurarchivWeb.LectureView do
  use KlausurarchivWeb, :view
  alias Ecto.Changeset

  def format_shortcuts(shortcuts) do
    Enum.map(shortcuts, &%{value: &1.id, text: &1.short})
  end

  def get_selected_degree(_degrees, filter) when filter == %{}, do: "all"

  def get_selected_degree(degrees, filter) do
    {_value, key} =
      Enum.find(degrees, fn {_v, key} ->
        key == filter["degree"]
      end)

    key
  end

  def get_unreviewed_shortcuts(lectures) do
    Enum.filter(lectures, fn lecture ->
      Enum.any?(lecture.shortcuts, fn shortcut -> shortcut end)
    end)
  end

  defp empty_filter?(filter) when filter == %{}, do: true

  defp empty_filter?(filter) do
    if filter["query"] == "" && filter["degree"] == "all" do
      true
    else
      false
    end
  end

  def fetch_degrees_from_lecture(changeset) do
    {_key, value} = Changeset.fetch_field(changeset, :degrees)
    value
  end

  def get_selected_degrees(data) do
    degrees = fetch_degrees_from_lecture(data)

    if Enum.empty?(degrees) do
      []
    else
      [selected: Enum.map(degrees, & &1.id)]
    end
  end

  def maybe_get_slug_or_id(lecture) do
    if !is_nil(lecture.slug) do
      lecture.slug
    else
      lecture.id
    end
  end
end
