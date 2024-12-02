defmodule Klausurarchiv.LecturesTest do
  use Klausurarchiv.DataCase

  alias Klausurarchiv.Lectures

  describe "lecture" do
    alias Klausurarchiv.Lectures.Lecture

    import Klausurarchiv.LecturesFixtures

    @invalid_attrs %{module_number: nil, name: nil, published: nil}

    test "list_lecture/0 returns all lecture" do
      lecture = lecture_fixture()
      assert Lectures.list_lecture() == [lecture]
    end

    test "get_lecture!/1 returns the lecture with given id" do
      lecture = lecture_fixture()
      assert Lectures.get_lecture!(lecture.id) == lecture
    end

    test "create_lecture/1 with valid data creates a lecture" do
      valid_attrs = %{module_number: "some module_number", name: "some name", published: true}

      assert {:ok, %Lecture{} = lecture} = Lectures.create_lecture(valid_attrs)
      assert lecture.module_number == "some module_number"
      assert lecture.name == "some name"
      assert lecture.published == true
    end

    test "create_lecture/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lectures.create_lecture(@invalid_attrs)
    end

    test "update_lecture/2 with valid data updates the lecture" do
      lecture = lecture_fixture()
      update_attrs = %{module_number: "some updated module_number", name: "some updated name", published: false}

      assert {:ok, %Lecture{} = lecture} = Lectures.update_lecture(lecture, update_attrs)
      assert lecture.module_number == "some updated module_number"
      assert lecture.name == "some updated name"
      assert lecture.published == false
    end

    test "update_lecture/2 with invalid data returns error changeset" do
      lecture = lecture_fixture()
      assert {:error, %Ecto.Changeset{}} = Lectures.update_lecture(lecture, @invalid_attrs)
      assert lecture == Lectures.get_lecture!(lecture.id)
    end

    test "delete_lecture/1 deletes the lecture" do
      lecture = lecture_fixture()
      assert {:ok, %Lecture{}} = Lectures.delete_lecture(lecture)
      assert_raise Ecto.NoResultsError, fn -> Lectures.get_lecture!(lecture.id) end
    end

    test "change_lecture/1 returns a lecture changeset" do
      lecture = lecture_fixture()
      assert %Ecto.Changeset{} = Lectures.change_lecture(lecture)
    end
  end
end
