defmodule KlausurarchivWeb.LectureView do
  use KlausurarchivWeb, :view

  def format_shortcuts(shortcuts) do
    Enum.map(shortcuts, & %{"value": &1.id,"text": &1.short})
  end

  def get_selected_degree(degrees, filter) when filter == %{}, do: "all"

  def get_selected_degree(degrees, filter) do
    {value, key} = Enum.find(degrees, fn {_v, key} ->
      key == filter["degree"]
    end)

    value
  end

  def get_unreviewed_shortcuts(lectures) do
    Enum.filter(lectures, fn lecture ->
      Enum.any?(lecture.shortcuts, fn shortcut -> shortcut end)
    end)
  end
end
