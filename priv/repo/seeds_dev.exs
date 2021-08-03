# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Klausurarchiv.Repo.insert!(%Klausurarchiv.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query, warn: false

alias Klausurarchiv.{Repo, User, Attachment}
alias Klausurarchiv.Uploads.{Degree, Lecture, Term, Exam}

User.create_user(%{
  "fore_name" => "Tobias",
  "last_name" => "Hoge",
  "user_name" => "tbho",
  "email" => "tbho@example.de",
  "password" => "Test123!",
  "password_confirmation" => "Test123!",
  "role" => "user"
})

User.create_user(%{
  "fore_name" => "Admin",
  "last_name" => "Account",
  "user_name" => "admin",
  "email" => "tbho+admin@example.de",
  "password" => "Test123!",
  "password_confirmation" => "Test123!",
  "role" => "admin"
})

# ---------------------------------------
# --- Create the six degrees
# ---------------------------------------

degrees = [
  "WI-Bachelor",
  "IS-Master",
  "BWL-Bachelor",
  "BWL-Master",
  "VWL-Bachelor",
  "VWL-Master"
]

degrees =
  Enum.map(degrees, fn degree ->
    %Degree{}
    |> Degree.changeset(%{"name" => degree, "lectures" => []})
    |> Repo.insert!()
  end)

# ---------------------------------------
# --- Create summer and winter terms
# ---------------------------------------

terms = [:summer_term, :winter_term]

terms =
  Enum.reduce(2000..2025, [], fn year, result ->
    result ++
      Enum.map(terms, fn type ->
        %Term{}
        |> Term.changeset(%{"year" => year, "type" => type})
        |> Repo.insert!()
      end)
  end)

# ---------------------------------------
# --- Create lectures
# ---------------------------------------

first = [
  "Allgemeine",
  "Umfassende",
  "Existentielle",
  "Advanced",
  "Einführung in die"
]

second = ["Bier", "Steuer", "Informatik", "Dille"]

third = ["Lehre", "Research", "Forschung", "Systeme", "Wirtschaft"]

lectures =
  Enum.map(1..10, fn _x ->
    degrees = Enum.take_random(degrees, Enum.random([1, 2]))

    name =
      Enum.random(first) <>
        " " <> Enum.random(second) <> " " <> Enum.random(third)

    %Lecture{}
    |> Lecture.changeset(%{
      "name" => name,
      "degrees" => degrees,
      "shortcuts" => []
    })
    |> Repo.insert!()
  end)

# ---------------------------------------
# --- Create exams
# ---------------------------------------

Enum.map(lectures, fn lecture ->
  Enum.map(1..3, fn _x ->
    term = Enum.random(terms)

    filename =
      Enum.random(["test_1.pdf", "test_2.pdf", "test_3.pdf", "test_4.pdf"])

    {:ok, attachment} =
      Attachment.create_attachment(%{
        "upload" => %Plug.Upload{
          content_type: "application/pdf",
          filename: "#{lecture.name}_#{term.type}_#{term.year}.pdf",
          path: "/app/priv/repo/demo_exam_files/" <> filename
        }
      })

    %Exam{}
    |> Exam.changeset(%{
      "lecture_id" => lecture.id,
      "term_id" => term.id,
      "published" => true,
      "attachment" => attachment
    })
    |> Repo.insert!()
  end)
end)

# Code.eval_file(
#     __ENV__.file
#     |> Path.dirname()
#     |> Path.join("exams.exs")
#   )
