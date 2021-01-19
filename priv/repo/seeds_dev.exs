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
      "email" => "tbho@tbho.de",
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
      "email" => "tbho+admin@tbho.de",
      "password" => "Test123!",
      "password_confirmation" => "Test123!",
      "role" => "admin"
    })

  admin ->
    admin
end
