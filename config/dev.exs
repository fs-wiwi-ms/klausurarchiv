use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
config :klausurarchiv, KlausurarchivWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# Watch static and templates for browser reloading.
config :klausurarchiv, KlausurarchivWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/klausurarchiv_web/views/.*(ex)$},
      ~r{lib/klausurarchiv_web/templates/.*(eex|slim|slime)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

config :klausurarchiv, KlausurarchivWeb.Endpoint,
  secret_key_base:
    "1234566789123456678912345667891234566789123456678912345667891234566789"

config :klausurarchiv,
  http_auth: [
    username: "admin",
    password: "admin"
  ]
