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

import Ecto.Query

alias Klausurarchiv.Repo
alias Klausurarchiv.Uploads.{Degree, Lecture, Term}

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
  "Datenmanagement",
  "Einführung in die Wirtschaftsinformatik",
  "Einführung VWL für Wirtschaftsinformatiker",
  "Electronic Business (eBusiness)",
  "Entscheidungstheorie und Entscheidungsuntersützungssysteme (ETEUS)",
  "Grundlagen der Betriebswirtschaftslehre",
  "Grundlagen des Marketing",
  "Informatik 1: Programmierung",
  "Informatik 2: Datenstrukturen und Algorithmen",
  "Informatik 3: Software Engineering",
  "Informatik 4: Rechnerstrukturen und Betriebssysteme",
  "IT-Recht",
  "Mathe für WiWis",
  "Operations Management",
  "Operations Research",
  "Projektmanagement",
  "Prozessmanagement und Anwendungssysteme"
]

is_master_lectures = [
  "Business Intelligence: Data Analytics I (Theory)",
  "Business Intelligence: Data Analytics II (Applications)",
  "Business Intelligence: Management Information Systems and Data Warehousing",
  "Business Networks: Enterprise Application Integration [bis 14/15]",
  "Business Networks: Information Security",
  "Business Networks: Interorganizational Systems",
  "Business Networks: Network Economics",
  "Elective: Rechnernetze (Dr. Ludger Becker)",
  "Information Management: Managing the Information Age Organization",
  "Information Management: Tasks and Techniques",
  "Information Management: Theories",
  "Information Systems Development: Advanced Concepts in Software Engineering",
  "Information Systems Development: Data Integration",
  "Information Systems Development: Logic Specification and Logic Programming",
  "Logistics Production and Retail - Retail",
  "Logistics Production and Retail: Production Planning and Control",
  "Logistics Production and Retail: Supply Chain Management and Logistics",
  "Process Management: Formal Specification",
  "Process Management: Enterprise Architecture Management",
  "Process Management: Information Modeling",
  "Process Management: Model-Driven Software Development [bis 14/15]",
  "Process Management: Workflow Management",
  "Process Management: Production Planning and Control"
]

bwl_bachelor_lectures = [
  "Betriebliche Finanzwirtschaft",
  "Bilanzen und Steuern",
  "Buchführung und Abschluss",
  "BWL II",
  "BWL II Englisch",
  "Corporate Finance",
  "Customer Management",
  "Einführung in die VWL",
  "Entscheidungs-Unterstützungsrechnung",
  "Finance und Accounting Seminar",
  "Finanzmathematik",
  "Grundlagen der Betriebswirtschaftslehre",
  "Grundlagen der Regulierung für BWLer",
  "Grundlagen der Transportwirtschaft und Logistik",
  "Grundlagen der Wirtschaftspolitik für BWLer",
  "Grundlagen des Marketing",
  "Healthcare & Hospital Management",
  "Industriegüter Marketing",
  "Integriertes Management-Seminar",
  "Internationales Management",
  "KoKo",
  "Logistikmanagement",
  "Makroökonomik I",
  "Market Research (siehe 'Quantitatives Marketing')",
  "Marketing Operations (siehe 'Quantitatives Marketing')",
  "Mathe für WiWis",
  "Mikroökonomik (Bachelor)",
  "Neue Institutionenökonomik für BWLer",
  "Öffentliche Betriebe",
  "Öffentliches Recht für Wirtschaftswissenschaftler",
  "Operations Management",
  "Organisation und Führung",
  "Planung und Entscheidung",
  "Planung und Entscheidungsrechnung",
  "Privat Recht I",
  "Privat Recht II",
  "Quantitatives Marketing",
  "Recht für Ökonomen",
  "Services Marketing",
  "Statistik I",
  "Statistik II",
  "Techniken der IT",
  "Unternehmenskooperation: Aktuelle Fälle",
  "Unternehmenskooperation: Governance",
  "Unternehmenskooperation: Management",
  "Unternehmensverfassung",
  "Versicherungsökonomie",
  "Vertiefung Accounting",
  "Vertiefung Finance",
  "Vertiefung Management",
  "Vertiefung Taxation",
  "Wirtschafts- und Unternehmensethik",
  "Wirtschaftsenglisch",
  "Wirtschaftsinformatik"
]

bwl_master_lectures = [
  "Advanced Corporate Finance",
  "Advanced Industrial Marketing",
  "Advanced Market Research",
  "Advanced Media Marketing",
  "Anwendungen des Controlling",
  "Ausgewählte Kapitel des Accounting I",
  "Ausgewählte Kapitel des Finance I",
  "Ausgewählte Kapitel des Finance II",
  "Ausgewählte Kapitel des Managements",
  "Ausgewählte Kapitel des Marketing I",
  "Ausgewählte Kapitel des Marketing II",
  "Behavioral Finance",
  "Brand Management and Integrated Communication",
  "BWL der Banken I",
  "BWL der Banken II",
  "Consumer Marketing",
  "Derivate II",
  "Derivatives I",
  "Direct Marketing",
  "F&E-Prozessmanagement",
  "Finanzintermediation II",
  "Gesellschaftsrecht II",
  "Handels- und Steuerbilanzen",
  "IFRS und Controlling",
  "Industrielle Beziehungen und Internationales",
  "International Marketing",
  "Internationale Rechnungslegung",
  "Internationale Unternehmensbesteuerung",
  "Internationales Controlling",
  "Introduction to Finance",
  "Konzepte und Instrumente des Controlling",
  "Marketing Strategy",
  "Media Marketing",
  "Modulabschlussklausur Management",
  "Modulabschlussklausur Organisation",
  "Modulabschlussklausur Personal",
  "Modulabschlussklausur Strategisches Management",
  "Organisation I",
  "Organisation II",
  "Personal I + II",
  "Sales Management",
  "Seminar Accounting I",
  "Seminar Marketing I",
  "Spezielles Steuerrecht",
  "Strategische Analyse",
  "Strategisches Management I",
  "Strategisches Management II + III",
  "Strategisches Management IV",
  "Unternehmensanalyse und -bewertung",
  "Versicherungsökonomie"
]

vwl_bachelor_lectures = [
  "Allgemeine Steuerlehre",
  "Angewandte Wirtschaftsforschung: Wirtschaftspolitik und Regulierung",
  "Außenwirtschaft",
  "Buchführung und Abschluss",
  "BWL II",
  "Customer Management",
  "Einführung in die VWL",
  "Einführung in die Wirtschaftsgeschichte",
  "Empirische Wirtschaftsforschung",
  "Energieökonomik I",
  "Finanzmathematik",
  "Fortgeschrittene Statistik",
  "Geldpolitik",
  "Geldtheorie",
  "Grundlagen der Betriebswirtschaftslehre",
  "Grundlagen der Transportwirtschaft und Logistik",
  "Grundlagen der Verkehrsökonomik",
  "Handelstheorie und -politik",
  "Industriegüter Marketing",
  "Konjunktur und Beschäftigung",
  "Makroökonomik I",
  "Markt- und Preistheorie",
  "Mathe für WiWis",
  "Mikroökonomik (Bachelor)",
  "Mikroökonomik III",
  "Monetäre Außenwirtschaft",
  "Monetäre Ökonomie",
  "Ökonometrie I",
  "Ökonometrie II",
  "Recht für Ökonomen",
  "Regionalökonomik: Grundlagen",
  "Regionalökonomik: Integrierte Wirtschaftsräume",
  "Seminar Allgemeine Volkswirtschaftslehre",
  "Services Marketing",
  "Spezielle Steuerlehre",
  "Spieltheorie",
  "Sportökonomik",
  "Statistik I",
  "Statistik II",
  "Techniken der IT",
  "Theorie der Unternehmung",
  "Umweltökonomik",
  "Unternehmenskooperation: Aktuelle Fälle",
  "Unternehmenskooperation: Governance",
  "Unternehmenskooperation: Management",
  "Wirtschaftsinformatik"
]

vwl_master_lectures = [
  "Aktuelle M&A-Fälle",
  "Aktuelle Themen der Volkswirtschaftslehre",
  "Aktuelle wirtschaftspolitische Entwicklungen",
  "Angewandte Mikroökonometrie",
  "Arbeitsmarkt und Beschäftigungspolitik",
  "Aufbaukurs Internationaler Handel",
  "Ausgewählte Kapitel in Ökonometrie, Statistik und empirischer Wirtschaftsforschung I",
  "Ausgewählte Kapitel in Ökonometrie, Statistik und empirischer Wirtschaftsforschung II",
  "Ausgewählte Themen der neueren Wirtschaftsgeschichte",
  "Ausgewählte Themen der Volkswirtschaftslehre",
  "Empirische Finanzwissenschaft",
  "Empirische Methoden",
  "Finanzpolitik",
  "Finanzwissenschaft",
  "Fortgeschrittene Energieökonomik I",
  "Fortgeschrittene Energieökonomik II",
  "Fortgeschrittene Finanzwissenschaft",
  "Fortgeschrittene Geldpolitik",
  "Fortgeschrittene Makroökonomie",
  "Fortgeschrittene Mikroökonomie",
  "Fortgeschrittene Mikroökonomie II",
  "Fortgeschrittene Monetäre Ökonomie",
  "Fortgeschrittene Sportökonomik",
  "Fortgeschrittene Verkehrsökonomik",
  "Geschichte der ökonomischen Theorie",
  "Handels- und Gesellschaftsrecht",
  "Internationale Makroökonomie",
  "Mathematische Methoden",
  "Mikroökonomik (Master)",
  "Ökonomische Theorie des Staates",
  "Regionalökonomik für Fortgeschrittene: Ökonomische Geografie",
  "Regulierungsökonomik",
  "Unternehmenskooperation: Mergers und Akquisitionen",
  "Volkswirtschaftspolitik",
  "Volkswirtschaftstheorie",
  "Zeitreihenanalyse"
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

    lecture = Repo.get_by(Lecture, name: x) |> Repo.preload([:degrees, :shortcuts])

    case lecture do
      nil ->
        %Lecture{}
        |> Lecture.changeset(%{"name" => x, "degrees" => [degree], "shortcuts" => []})
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

if System.get_env("ENV_NAME") != "production" do
  Code.eval_file(
    __ENV__.file
    |> Path.dirname()
    |> Path.join("seeds_dev.exs")
  )

  Code.eval_file(
    __ENV__.file
    |> Path.dirname()
    |> Path.join("exams.exs")
  )
end
