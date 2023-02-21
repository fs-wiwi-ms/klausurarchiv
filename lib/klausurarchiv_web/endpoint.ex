defmodule KlausurarchivWeb.Endpoint do
  use Sentry.PlugCapture
  use Phoenix.Endpoint, otp_app: :klausurarchiv
  use Appsignal.Phoenix

  @session_options [
    store: :cookie,
    key: "klausurarchiv_session",
    signing_salt: "5W54z+xr"
  ]

  plug(KlausurarchivWeb.Plugs.WellKnown)

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

  plug(KlausurarchivWeb.Plugs.PublicIp)

  plug(KlausurarchivWeb.Router)

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]]
end
