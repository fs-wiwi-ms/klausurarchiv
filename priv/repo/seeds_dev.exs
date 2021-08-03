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

alias Klausurarchiv.Repo
alias Klausurarchiv.User
import Ecto.Query, warn: false

alias Klausurarchiv.Uploads.{Degree, Lecture, Term}

user =
  User
  |> where([u], u.email == ^"tbho@tbho.de")
  |> Repo.one()

case user do
  nil ->
    User.create_user(%{
      "fore_name" => "Tobias",
      "last_name" => "Hoge",
      "user_name" => "tbho",
      "email" => "tbho@example.de",
      "password" => "Test123!",
      "password_confirmation" => "Test123!",
      "role" => "user"
    })

  user ->
    user
end

admin =
  User
  |> where([u], u.email == ^"tbho+admin@tbho.de")
  |> Repo.one()

case admin do
  nil ->
    User.create_user(%{
      "fore_name" => "Admin",
      "last_name" => "Account",
      "user_name" => "admin",
      "email" => "tbho+admin@example.de",
      "password" => "Test123!",
      "password_confirmation" => "Test123!",
      "role" => "admin"
    })

  admin ->
    admin
end

degrees = [
  "WI-Bachelor",
  "IS-Master",
  "BWL-Bachelor",
  "BWL-Master",
  "VWL-Bachelor",
  "VWL-Master"
]

terms = [:summer_term, :winter_term]

wi_bachelor_lectures = [
  "Buchführung und Abschluss",
  "BWL II",
  "Communication and Collaboration Systems",
  "Daten und Wahrscheinlichkeiten",
  "Datenanalyse und Simulation",
]

is_master_lectures = [
  "Business Intelligence: Data Analytics I (Theory)",
  "Business Intelligence: Data Analytics II (Applications)",
  "Business Intelligence: Management Information Systems and Data Warehousing",
  "Business Networks: Information Security",
  "Business Networks: Interorganizational Systems",
  "Business Networks: Network Economics",
]

bwl_bachelor_lectures = [
  "Betriebliche Finanzwirtschaft",
  "Bilanzen und Steuern",
  "Buchführung und Abschluss",
  "BWL II",
  "BWL II Englisch",
  "Corporate Finance"
]

bwl_master_lectures = [
  "Advanced Corporate Finance",
  "Advanced Industrial Marketing",
  "Advanced Market Research",
  "Advanced Media Marketing",
  "Anwendungen des Controlling",
  "Ausgewählte Kapitel des Accounting I",
  "Ausgewählte Kapitel des Finance I",
  "Ausgewählte Kapitel des Finance II"
]

vwl_bachelor_lectures = [
  "Allgemeine Steuerlehre",
  "Angewandte Wirtschaftsforschung: Wirtschaftspolitik und Regulierung",
  "Außenwirtschaft",
  "Buchführung und Abschluss",
  "BWL II",
  "Customer Management",
  "Einführung in die VWL",
]

vwl_master_lectures = [
  "Aktuelle M&A-Fälle",
  "Aktuelle Themen der Volkswirtschaftslehre",
  "Aktuelle wirtschaftspolitische Entwicklungen",
  "Angewandte Mikroökonometrie",
  "Arbeitsmarkt und Beschäftigungspolitik",
  "Aufbaukurs Internationaler Handel"
]

create_entities_with_preload = fn list ->
  Enum.map(list, fn {mod, identifier, preload, params} ->
    case Repo.get_by(mod, identifier) |> Repo.preload(preload) do
      nil ->
        mod
        |> apply(:changeset, [struct(mod), params])
        |> Repo.insert!()

      entity ->
        mod
        |> apply(:changeset, [entity, params])
        |> Repo.update!()
    end
  end)
end

Enum.map(
  degrees,
  &{Degree, [name: &1], [:lectures], %{"name" => &1, "lectures" => []}}
)
|> create_entities_with_preload.()

Enum.map(2000..2025, fn year ->
  Enum.map(terms, fn type ->
    term =
      Term
      |> where([t], t.year == ^year and t.type == ^type)
      |> Repo.one()

    case term do
      nil ->
        %Term{}
        |> Term.changeset(%{"year" => year, "type" => type})
        |> Repo.insert!()

      term ->
        term
    end
  end)
end)

degree_lectures = [
  {"WI-Bachelor", wi_bachelor_lectures},
  {"IS-Master", is_master_lectures},
  {"BWL-Bachelor", bwl_bachelor_lectures},
  {"BWL-Master", bwl_master_lectures},
  {"VWL-Bachelor", vwl_bachelor_lectures},
  {"VWL-Master", vwl_master_lectures}
]

Enum.map(degree_lectures, fn {degree_name, lectures} ->
  Enum.map(lectures, fn x ->
    degree = Repo.get_by(Degree, name: degree_name)

    lecture =
      Repo.get_by(Lecture, name: x) |> Repo.preload([:degrees, :shortcuts])

    case lecture do
      nil ->
        %Lecture{}
        |> Lecture.changeset(%{
          "name" => x,
          "degrees" => [degree],
          "shortcuts" => []
        })
        |> Repo.insert!()

      lecture ->
        degrees =
          Enum.reduce(
            [degree.id] || [],
            lecture.degrees,
            &[Repo.get(Degree, &1) | &2]
          )

        lecture
        |> Lecture.changeset(%{"degrees" => degrees, "shortcuts" => []})
        |> Repo.update!()
    end
  end)
end)
