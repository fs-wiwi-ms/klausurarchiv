
{:ok, files} = File.ls("/app/exam-files/")

alias Klausurarchiv.{Repo, Attachment}
alias Klausurarchiv.Uploads.{Degree, Lecture, Term, Exam}

exams = Klausurarchiv.Uploads.get_exams

Enum.map(exams, fn exam ->
  if Enum.any?(files, &(&1 == exam.filename)) do
    {:ok, attachment} = Attachment.create_attachment(%{
      "upload" => %Plug.Upload{
        content_type: "application/pdf",
        filename: exam.filename,
        path: "/app/exam-files/" <> exam.filename
      }
    })

    {:ok, exam} = exam
    |> Repo.preload([:attachment])
    |> Exam.changeset(%{"attachment" => attachment})
    |> Repo.update()

    exam
  else
    raise "File not found"
    IO.inspect(exam)
  end
end)
|> IO.inspect
