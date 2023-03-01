defmodule Klausurarchiv.Email do
  use Bamboo.Phoenix, view: KlausurarchivWeb.EmailView

  alias Klausurarchiv.Mailer

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
    |> Mailer.deliver_now()
  end

  @doc "Creates a new email for a newly uploaded exam and sends it to all admins"
  def new_exam_uploaded_email(user, exam) do
    new_email()
    |> to(user.email)
    |> from(System.get_env("SMTP_FROM_ADDRESS"))
    |> subject(Gettext.dgettext(KlausurarchivWeb.Gettext, "email", "new_exam"))
    |> assign(:user, user)
    |> assign(:exam, exam)
    |> put_text_layout({KlausurarchivWeb.LayoutView, "email.text"})
    |> put_html_layout({KlausurarchivWeb.LayoutView, "email.html"})
    |> render("new_exam_uploaded.html")
    |> Mailer.deliver_now()
  end
end
