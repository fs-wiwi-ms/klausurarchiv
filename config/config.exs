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
  log: false,
  start_apps_before_migration: [:ssl]

# Configures the endpoint
config :klausurarchiv, KlausurarchivWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: KlausurarchivWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Klausurarchiv.PubSub,
  secret_key_base:
    "5HjSFjyGix751ubR/igyrzbfby3NsOc2Dn4DxldR4hpoqKIa3YEosx3psppajJRw",
  live_view: [signing_salt: "pwCwZuECFRuIQKmFS1mblLgc68jg5dOw"]

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

config :ex_aws,
  json_codec: Jason,
  region: "eu-central-1"

config :klausurarchiv, Klausurarchiv.Scheduler,
jobs: [
  # Runs every midnight:
  {"@daily", {Klausurarchiv.User.Session, :clear_stale_session, []}},
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
