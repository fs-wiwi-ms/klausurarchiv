defmodule KlausurarchivWeb.LectureLiveTest do
  use KlausurarchivWeb.ConnCase

  import Phoenix.LiveViewTest
  import Klausurarchiv.UploadsFixtures

  @create_attrs %{module_number: "some module_number", name: "some name", published: true}
  @update_attrs %{module_number: "some updated module_number", name: "some updated name", published: false}
  @invalid_attrs %{module_number: nil, name: nil, published: false}

  defp create_lecture(_) do
    lecture = lecture_fixture()
    %{lecture: lecture}
  end

  describe "Index" do
    setup [:create_lecture]

    test "lists all lecture", %{conn: conn, lecture: lecture} do
      {:ok, _index_live, html} = live(conn, Routes.lecture_index_path(conn, :index))

      assert html =~ "Listing Lecture"
      assert html =~ lecture.module_number
    end

    test "saves new lecture", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.lecture_index_path(conn, :index))

      assert index_live |> element("a", "New Lecture") |> render_click() =~
               "New Lecture"

      assert_patch(index_live, Routes.lecture_index_path(conn, :new))

      assert index_live
             |> form("#lecture-form", lecture: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#lecture-form", lecture: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.lecture_index_path(conn, :index))

      assert html =~ "Lecture created successfully"
      assert html =~ "some module_number"
    end

    test "updates lecture in listing", %{conn: conn, lecture: lecture} do
      {:ok, index_live, _html} = live(conn, Routes.lecture_index_path(conn, :index))

      assert index_live |> element("#lecture-#{lecture.id} a", "Edit") |> render_click() =~
               "Edit Lecture"

      assert_patch(index_live, Routes.lecture_index_path(conn, :edit, lecture))

      assert index_live
             |> form("#lecture-form", lecture: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#lecture-form", lecture: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.lecture_index_path(conn, :index))

      assert html =~ "Lecture updated successfully"
      assert html =~ "some updated module_number"
    end

    test "deletes lecture in listing", %{conn: conn, lecture: lecture} do
      {:ok, index_live, _html} = live(conn, Routes.lecture_index_path(conn, :index))

      assert index_live |> element("#lecture-#{lecture.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#lecture-#{lecture.id}")
    end
  end

  describe "Show" do
    setup [:create_lecture]

    test "displays lecture", %{conn: conn, lecture: lecture} do
      {:ok, _show_live, html} = live(conn, Routes.lecture_show_path(conn, :show, lecture))

      assert html =~ "Show Lecture"
      assert html =~ lecture.module_number
    end

    test "updates lecture within modal", %{conn: conn, lecture: lecture} do
      {:ok, show_live, _html} = live(conn, Routes.lecture_show_path(conn, :show, lecture))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Lecture"

      assert_patch(show_live, Routes.lecture_show_path(conn, :edit, lecture))

      assert show_live
             |> form("#lecture-form", lecture: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#lecture-form", lecture: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.lecture_show_path(conn, :show, lecture))

      assert html =~ "Lecture updated successfully"
      assert html =~ "some updated module_number"
    end
  end
end
