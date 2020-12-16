defmodule KlausurarchivWeb.Authentication do
  @moduledoc "Plug-compliant functions to authenticate requests"

  alias Klausurarchiv.User.Session
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3, get_format: 1]

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, type: :browser, forward_to_login: forward_to_login) do
    access_token = get_session(conn, :access_token) || ""
    refresh_token = conn.cookies["refresh_token"] || ""

    case Session.verify_session(access_token, refresh_token) do
      {:ok, %{refresh_token: nil} = session} ->
        conn
        |> put_session(:access_token, session.access_token)
        |> put_session(:user_id, session.user_id)
        |> assign(:session, session)

      {:ok, session} ->
        conn
        |> put_session(:access_token, session.access_token)
        |> put_session(:user_id, session.user_id)
        |> put_resp_cookie("refresh_token", session.refresh_token)
        |> assign(:session, session)

      {:error, _} ->
        if forward_to_login do
          conn
          |> put_session(:redirect_url, conn.request_path)
          |> put_flash(:info, "Please login to continue.")
          |> redirect(to: KlausurarchivWeb.Router.Helpers.public_session_path(conn, :new))
          |> halt()
        else
          conn
        end
    end
  end

  def call(conn, type: :api) do
    with ["Bearer " <> access_token] <- get_req_header(conn, "authorization"),
         {:ok, session} <- Session.verify_session(access_token, nil) do
      assign(conn, :session, session)
    else
      _other ->
        conn
        |> put_status(:unauthorized)
        |> halt()
    end
  end

  def call(conn, type: :api_or_browser, forward_to_login: forward_to_login) do
    case get_format(conn) do
      "json" ->
        call(conn, type: :api)

      "html" ->
        call(conn, type: :browser, forward_to_login: forward_to_login)
    end
  end

  # def call(conn, type: :graphql) do
  #   with ["Bearer " <> access_token] <- get_req_header(conn, "authorization"),
  #        {:ok, session} <- Accounts.verify_session(access_token, nil) do
  #     Absinthe.Plug.put_options(conn, context: %{current_session: session})
  #   else
  #     other ->
  #       other
  #       conn
  #   end
  # end

  # def call(%Absinthe.Resolution{context: %{current_session: _}} = resolution, _) do
  #   resolution
  # end

  # def call(resolution, _) do
  #   Absinthe.Resolution.put_result(resolution, {:error, "unauthorized"})
  # end
end
