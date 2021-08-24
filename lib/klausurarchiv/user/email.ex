defmodule Klausurarchiv.User.Email do
  import Bamboo.Email
  import KlausurarchivWeb.Gettext

  @doc "Creates a new email for user with password_reset_url and password_reset_token"
  def password_reset_email(user, token) do
    password_reset_url =
      KlausurarchivWeb.Router.Helpers.public_password_reset_token_path(
        KlausurarchivWeb.Endpoint,
        :show,
        token.token
      )

    new_email()
    |> to(user.email)
    |> from(System.get_env("SMTP_FROM_ADDRESS"))
    |> subject(dgettext("email", "reset_password"))
    |> html_body("https://" <> System.get_env("HOST") <> password_reset_url)
    |> text_body("https://" <> System.get_env("HOST") <> password_reset_url)
  end

  @doc "Creates a new email for user with password_reset_url and password_reset_token"
  def account_confirmation_email(user, token) do
    account_confirmation_url =
      KlausurarchivWeb.Router.Helpers.public_password_reset_token_path(
        KlausurarchivWeb.Endpoint,
        :show,
        token.token
      )

    new_email()
    |> to(user.email)
    |> from(System.get_env("SMTP_FROM_ADDRESS"))
    |> subject(dgettext("email", "confirm_account"))
    |> html_body("https://" <> System.get_env("HOST") <> account_confirmation_url)
    |> text_body("https://" <> System.get_env("HOST") <> account_confirmation_url)
  end
end
