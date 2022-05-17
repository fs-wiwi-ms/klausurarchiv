defmodule KlausurarchivWeb.PageView do
  use KlausurarchivWeb, :view

  alias Klausurarchiv.Uploads

  def get_unplublished_shortcuts_count() do
    Uploads.get_unplublished_shortcuts_count()
  end

    def get_unplublished_exams_count() do
    Uploads.get_unplublished_exams_count()
  end
end
