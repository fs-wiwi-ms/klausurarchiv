defmodule Klausurarchiv.UploadsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Klausurarchiv.Uploads` context.
  """

  @doc """
  Generate a lecture.
  """
  def lecture_fixture(attrs \\ %{}) do
    {:ok, lecture} =
      attrs
      |> Enum.into(%{
        module_number: "some module_number",
        name: "some name",
        published: true
      })
      |> Klausurarchiv.Uploads.create_lecture()

    lecture
  end

  @doc """
  Generate a shortcut.
  """
  def shortcut_fixture(attrs \\ %{}) do
    {:ok, shortcut} =
      attrs
      |> Enum.into(%{
        name: "some name",
        published: true
      })
      |> Klausurarchiv.Uploads.create_shortcut()

    shortcut
  end
end
