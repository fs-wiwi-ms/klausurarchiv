# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :klausurarchiv,
  ecto_repos: [Klausurarchiv.Repo]

config :slime, :keep_lines, true

# Configures the endpoint
config :klausurarchiv, KlausurarchivWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "SshedBcjDQiBjPm5Yy8QS/hC9TgbkkOeVI1YyDhrZENoiXmxlxcigR9wxBu4AUA7",
  render_errors: [view: KlausurarchivWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Klausurarchiv.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :klausurarchiv,
  http_auth: [
    username: System.get_env("USER"),
    password: System.get_env("PASSWORD")
  ]

config :klausurarchiv, KlausurarchivWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :klausurarchiv, Klausurarchiv.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool_size: 15

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

