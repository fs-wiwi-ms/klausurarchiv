use Mix.Config

# Configure your database
config :klausurarchiv, Klausurarchiv.Repo,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :klausurarchiv, KlausurarchivWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [],
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/klausurarchiv_web/views/.*(ex)$},
      ~r{lib/klausurarchiv_web/templates/.*(eex|slim|slime)$}
    ]
  ],
  secret_key_base:
    "5HjSFjyGix751ubR/igyrzbfby3NsOc2Dn4DxldR4hpoqKIa3YEosx3psppajJRw",
  live_view: [signing_salt: "pwCwZuECFRuIQKmFS1mblLgc68jg5dOw"]

config :slime, :keep_lines, true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

config :klausurarchiv, Klausurarchiv.Mailer, adapter: Bamboo.LocalAdapter

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
