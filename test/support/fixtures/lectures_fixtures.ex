defmodule Klausurarchiv.LecturesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Klausurarchiv.Lectures` context.
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
      |> Klausurarchiv.Lectures.create_lecture()

    lecture
  end
end
