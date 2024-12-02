defmodule Klausurarchiv.UploadsTest do
  use Klausurarchiv.DataCase

  alias Klausurarchiv.Uploads

  describe "lecture" do
    alias Klausurarchiv.Uploads.Lecture

    import Klausurarchiv.UploadsFixtures

    @invalid_attrs %{module_number: nil, name: nil, published: nil}

    test "list_lecture/0 returns all lecture" do
      lecture = lecture_fixture()
      assert Uploads.list_lecture() == [lecture]
    end

    test "get_lecture!/1 returns the lecture with given id" do
      lecture = lecture_fixture()
      assert Uploads.get_lecture!(lecture.id) == lecture
    end

    test "create_lecture/1 with valid data creates a lecture" do
      valid_attrs = %{module_number: "some module_number", name: "some name", published: true}

      assert {:ok, %Lecture{} = lecture} = Uploads.create_lecture(valid_attrs)
      assert lecture.module_number == "some module_number"
      assert lecture.name == "some name"
      assert lecture.published == true
    end

    test "create_lecture/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Uploads.create_lecture(@invalid_attrs)
    end

    test "update_lecture/2 with valid data updates the lecture" do
      lecture = lecture_fixture()
      update_attrs = %{module_number: "some updated module_number", name: "some updated name", published: false}

      assert {:ok, %Lecture{} = lecture} = Uploads.update_lecture(lecture, update_attrs)
      assert lecture.module_number == "some updated module_number"
      assert lecture.name == "some updated name"
      assert lecture.published == false
    end

    test "update_lecture/2 with invalid data returns error changeset" do
      lecture = lecture_fixture()
      assert {:error, %Ecto.Changeset{}} = Uploads.update_lecture(lecture, @invalid_attrs)
      assert lecture == Uploads.get_lecture!(lecture.id)
    end

    test "delete_lecture/1 deletes the lecture" do
      lecture = lecture_fixture()
      assert {:ok, %Lecture{}} = Uploads.delete_lecture(lecture)
      assert_raise Ecto.NoResultsError, fn -> Uploads.get_lecture!(lecture.id) end
    end

    test "change_lecture/1 returns a lecture changeset" do
      lecture = lecture_fixture()
      assert %Ecto.Changeset{} = Uploads.change_lecture(lecture)
    end
  end

  describe "shortcut" do
    alias Klausurarchiv.Uploads.Shortcut

    import Klausurarchiv.UploadsFixtures

    @invalid_attrs %{name: nil, published: nil}

    test "list_shortcut/0 returns all shortcut" do
      shortcut = shortcut_fixture()
      assert Uploads.list_shortcut() == [shortcut]
    end

    test "get_shortcut!/1 returns the shortcut with given id" do
      shortcut = shortcut_fixture()
      assert Uploads.get_shortcut!(shortcut.id) == shortcut
    end

    test "create_shortcut/1 with valid data creates a shortcut" do
      valid_attrs = %{name: "some name", published: true}

      assert {:ok, %Shortcut{} = shortcut} = Uploads.create_shortcut(valid_attrs)
      assert shortcut.name == "some name"
      assert shortcut.published == true
    end

    test "create_shortcut/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Uploads.create_shortcut(@invalid_attrs)
    end

    test "update_shortcut/2 with valid data updates the shortcut" do
      shortcut = shortcut_fixture()
      update_attrs = %{name: "some updated name", published: false}

      assert {:ok, %Shortcut{} = shortcut} = Uploads.update_shortcut(shortcut, update_attrs)
      assert shortcut.name == "some updated name"
      assert shortcut.published == false
    end

    test "update_shortcut/2 with invalid data returns error changeset" do
      shortcut = shortcut_fixture()
      assert {:error, %Ecto.Changeset{}} = Uploads.update_shortcut(shortcut, @invalid_attrs)
      assert shortcut == Uploads.get_shortcut!(shortcut.id)
    end

    test "delete_shortcut/1 deletes the shortcut" do
      shortcut = shortcut_fixture()
      assert {:ok, %Shortcut{}} = Uploads.delete_shortcut(shortcut)
      assert_raise Ecto.NoResultsError, fn -> Uploads.get_shortcut!(shortcut.id) end
    end

    test "change_shortcut/1 returns a shortcut changeset" do
      shortcut = shortcut_fixture()
      assert %Ecto.Changeset{} = Uploads.change_shortcut(shortcut)
    end
  end
end
