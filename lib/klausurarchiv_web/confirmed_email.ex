defmodule KlausurarchivWeb.ConfirmedEmail do
  @moduledoc "Plug-compliant functions to check if a user is admin"

  alias Klausurarchiv.Users
  alias Klausurarchiv.Users.User
  import Plug.Conn
  import KlausurarchivWeb.Gettext

  import Phoenix.Controller,
    only: [put_flash: 3, render: 2, put_view: 2, redirect: 2]

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, _) do
    with user_id when not is_nil(user_id) <- get_session(conn, :user_id),
         %User{} = user <- Users.get_user(user_id) do
      if !user.email_confirmed do
        conn
        |> put_flash(:error, gettext("This action is permitted!"))
        |> redirect(
          to:
            KlausurarchivWeb.Router.Helpers.account_confirmation_path(
              conn,
              :not_confirmed
            )
        )
        |> halt()
      else
        conn
      end
    else
      nil ->
        conn
        |> put_flash(:error, gettext("This action is permitted!"))
        |> put_status(:unauthorized)
        |> put_view(KlausurarchivWeb.ErrorView)
        |> render("401.html")
        |> halt()
    end

    conn
  end
end
