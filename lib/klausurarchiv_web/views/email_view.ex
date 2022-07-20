defmodule KlausurarchivWeb.EmailView do
  use KlausurarchivWeb, :view

  def password_reset_url(token) do
    System.get_env("HOST") <>
      KlausurarchivWeb.Router.Helpers.public_password_reset_token_path(
        KlausurarchivWeb.Endpoint,
        :show,
        token.token
      )
  end

  def account_confirmation_url(token) do
    System.get_env("HOST") <>
      KlausurarchivWeb.Router.Helpers.public_account_confirmation_path(
        KlausurarchivWeb.Endpoint,
        :confirm_mail,
        token.token
      )
  end
end
