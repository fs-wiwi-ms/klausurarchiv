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

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :klausurarchiv, KlausurarchivWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  url: [
    host: System.get_env("HOST"),
    port: 443,
    scheme: "https"
  ],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base,

sentry_dsn =
System.get_env("SENTRY_DSN") ||
  raise """
  environment variable SENTRY_DSN is missing.
  You can generate one by calling: mix phx.gen.secret
  """

config :sentry,
  dsn: sentry_dsn,
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod]


config :logger,
  backends: [:console, Sentry.LoggerBackend]
