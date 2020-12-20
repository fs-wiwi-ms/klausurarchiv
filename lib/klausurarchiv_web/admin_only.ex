defmodule KlausurarchivWeb.AdminOnly do
  @moduledoc "Plug-compliant functions to check if a user is admin"

  alias Klausurarchiv.User
  import Plug.Conn
  import KlausurarchivWeb.Gettext
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

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
        |> put_flash(:error, gettext("This action is permitted!"))
        |> redirect(to: KlausurarchivWeb.Router.Helpers.page_path(conn, :index))
    end
  end
end
