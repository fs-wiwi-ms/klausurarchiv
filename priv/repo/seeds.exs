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
