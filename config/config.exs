# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :klausurarchiv,
  ecto_repos: [Klausurarchiv.Repo]

# Configure your database
config :klausurarchiv, Klausurarchiv.Repo,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  log: false

# Configures the endpoint
config :klausurarchiv, KlausurarchivWeb.Endpoint,
  http: [:inet6, port: 4000],
  url: [host: "localhost"],
  render_errors: [view: KlausurarchivWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Klausurarchiv.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine

config :phoenix, :json_library, Jason

config :gettext, :default_locale, "de"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
