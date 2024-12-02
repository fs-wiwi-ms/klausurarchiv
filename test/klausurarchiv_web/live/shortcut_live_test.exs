defmodule KlausurarchivWeb.ShortcutLiveTest do
  use KlausurarchivWeb.ConnCase

  import Phoenix.LiveViewTest
  import Klausurarchiv.UploadsFixtures

  @create_attrs %{name: "some name", published: true}
  @update_attrs %{name: "some updated name", published: false}
  @invalid_attrs %{name: nil, published: false}

  defp create_shortcut(_) do
    shortcut = shortcut_fixture()
    %{shortcut: shortcut}
  end

  describe "Index" do
    setup [:create_shortcut]

    test "lists all shortcut", %{conn: conn, shortcut: shortcut} do
      {:ok, _index_live, html} = live(conn, Routes.shortcut_index_path(conn, :index))

      assert html =~ "Listing Shortcut"
      assert html =~ shortcut.name
    end

    test "saves new shortcut", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.shortcut_index_path(conn, :index))

      assert index_live |> element("a", "New Shortcut") |> render_click() =~
               "New Shortcut"

      assert_patch(index_live, Routes.shortcut_index_path(conn, :new))

      assert index_live
             |> form("#shortcut-form", shortcut: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#shortcut-form", shortcut: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shortcut_index_path(conn, :index))

      assert html =~ "Shortcut created successfully"
      assert html =~ "some name"
    end

    test "updates shortcut in listing", %{conn: conn, shortcut: shortcut} do
      {:ok, index_live, _html} = live(conn, Routes.shortcut_index_path(conn, :index))

      assert index_live |> element("#shortcut-#{shortcut.id} a", "Edit") |> render_click() =~
               "Edit Shortcut"

      assert_patch(index_live, Routes.shortcut_index_path(conn, :edit, shortcut))

      assert index_live
             |> form("#shortcut-form", shortcut: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#shortcut-form", shortcut: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shortcut_index_path(conn, :index))

      assert html =~ "Shortcut updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes shortcut in listing", %{conn: conn, shortcut: shortcut} do
      {:ok, index_live, _html} = live(conn, Routes.shortcut_index_path(conn, :index))

      assert index_live |> element("#shortcut-#{shortcut.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#shortcut-#{shortcut.id}")
    end
  end

  describe "Show" do
    setup [:create_shortcut]

    test "displays shortcut", %{conn: conn, shortcut: shortcut} do
      {:ok, _show_live, html} = live(conn, Routes.shortcut_show_path(conn, :show, shortcut))

      assert html =~ "Show Shortcut"
      assert html =~ shortcut.name
    end

    test "updates shortcut within modal", %{conn: conn, shortcut: shortcut} do
      {:ok, show_live, _html} = live(conn, Routes.shortcut_show_path(conn, :show, shortcut))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Shortcut"

      assert_patch(show_live, Routes.shortcut_show_path(conn, :edit, shortcut))

      assert show_live
             |> form("#shortcut-form", shortcut: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#shortcut-form", shortcut: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shortcut_show_path(conn, :show, shortcut))

      assert html =~ "Shortcut updated successfully"
      assert html =~ "some updated name"
    end
  end
end
