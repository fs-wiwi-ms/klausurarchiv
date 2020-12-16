defmodule KlausurarchivWeb.AdminOnly do
  @moduledoc "Plug-compliant functions to check if a user is admin"

  alias Klausurarchiv.User
  import Plug.Conn

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, _) do
    user =
      conn
      |> get_session(:user_id)
      |> User.get_user()

    case user.role do
      :admin ->
        conn

      :user ->
        conn
        |> put_status(:unauthorized)
        |> halt()
    end
  end
end
