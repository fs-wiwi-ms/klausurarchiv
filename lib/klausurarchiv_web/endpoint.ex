defmodule KlausurarchivWeb.Endpoint do
  use Sentry.PlugCapture
  use Phoenix.Endpoint, otp_app: :klausurarchiv

  @session_options [
    store: :cookie,
    key: "_my_app_key",
    signing_salt: "5W54z+xr"
  ]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :klausurarchiv,
    gzip: false,
    only: ~w(css fonts images js favicon.png robots.txt manifest.json)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug Sentry.PlugContext

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(Plug.Session, @session_options)

  plug(KlausurarchivWeb.Router)

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]]

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration.
  """
  @spec init(atom, Keyword.t()) :: {:ok, Keyword.t()} | no_return
  def init(_key, config) do
    secret_key_base =
      System.get_env("SECRET_KEY_BASE") ||
        raise """
        environment variable SECRET_KEY_BASE is missing.
        You can generate one by calling: mix phx.gen.secret
        """

    live_view_signing_salt =
      System.get_env("LIVE_VIEW_SALT") ||
        raise """
        environment variable LIVE_VIEW_SALT is missing.
        You can generate one by calling: mix phx.gen.secret
        """

    config =
      config
      |> Keyword.put(:secret_key_base, secret_key_base)
      |> Keyword.put(:live_view,
        signing_salt: live_view_signing_salt
      )

    {:ok, config}
  end
end
