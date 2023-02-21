defmodule Klausurarchiv.User.Email do
  use Bamboo.Phoenix, view: KlausurarchivWeb.EmailView

  @doc "Creates a new email for user and token (either account_confirmation or reset_password)"
  def token_email(user, token, layout) do
    new_email()
    |> to(user.email)
    |> from(System.get_env("SMTP_FROM_ADDRESS"))
    |> subject(
      Gettext.dgettext(
        KlausurarchivWeb.Gettext,
        "email",
        Atom.to_string(layout)
      )
    )
    |> assign(:user, user)
    |> assign(:token, token)
    |> put_text_layout({KlausurarchivWeb.LayoutView, "email.text"})
    |> put_html_layout({KlausurarchivWeb.LayoutView, "email.html"})
    |> render(Atom.to_string(layout) <> ".html")
  end
end
