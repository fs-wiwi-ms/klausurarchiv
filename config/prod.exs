use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# KlausurarchivWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.

# Please config your environment variables as following:

# LIVE_VIEW_SALT=<salt> (You can generate one by calling: mix phx.gen.secret)
# PORT=4000
# HOST=example.com
# SECRET_KEY_BASE=<salt> (You can generate one by calling: mix phx.gen.secret)

config :klausurarchiv, KlausurarchivWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  url: [
    port: 443,
    scheme: "https",
    host: System.get_env("HOST")
  ],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")]

# Please config your environment variables as following:

# SENTRY_DSN=https://randomnumberstring@random.ingest.sentry.io/random

config :sentry,
  dsn: {:system, "SENTRY_DSN"},
  environment_name: System.get_env("SENTRY_ENV") || "prod",
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod, :staging]

# Please config your environment variables as following:

# SMTP_PASSWORD=password
# SMTP_PORT=587
# SMTP_SERVER=smtp.example.com
# SMTP_USERNAME=username

config :klausurarchiv, DeepMrt.Mailer,
  adapter: Bamboo.SMTPAdapter,
  tls: :always,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 1,
  no_mx_lookups: false,
  auth: :always

config :logger,
  backends: [:console, Sentry.LoggerBackend]
