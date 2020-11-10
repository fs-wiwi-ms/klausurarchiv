defmodule Klausurarchiv.Repo do
  use Ecto.Repo,
    otp_app: :klausurarchiv,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

    {:ok, Keyword.put(opts, :url, database_url)}
  end
end
