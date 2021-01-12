defmodule KlausurarchivWeb.AdminOnly do
  @moduledoc "Plug-compliant functions to check if a user is admin"

  alias Klausurarchiv.User
  import Plug.Conn
  import KlausurarchivWeb.Gettext
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2, render: 3]

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, _) do
      with user_id when not is_nil(user_id) <- get_session(conn, :user_id),
      %User{} = user <- User.get_user(user_id) do
        case user.role do
          :admin ->
            conn

          :user ->
            conn
            |> put_flash(:error, gettext("This action is permitted!"))
            |> put_status(:unauthorized)
            |> render(KlausurarchivWeb.ErrorView, "401.html")
          end
        else
          nil ->
            conn
            |> put_flash(:error, gettext("This action is permitted!"))
            |> put_status(:unauthorized)
            |> render(KlausurarchivWeb.ErrorView, "401.html")
        end
  end
end
