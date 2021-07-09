defmodule Klausurarchiv.Repo do
  use Ecto.Repo,
    otp_app: :klausurarchiv,
    adapter: Ecto.Adapters.Postgres
end
