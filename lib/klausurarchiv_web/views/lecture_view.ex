defmodule KlausurarchivWeb.LectureView do
  use KlausurarchivWeb, :view

  def format_shorts(shorts) do
    Enum.map(shorts, & %{"value": &1.id,"text": &1.short})
  end
end
