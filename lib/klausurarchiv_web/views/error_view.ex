defmodule KlausurarchivWeb.ErrorView do
  use KlausurarchivWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("401.html", assigns) do
    render(
      __MODULE__,
      "unauthorized.html",
      Map.put(assigns, :layout, {KlausurarchivWeb.LayoutView, "error.html"})
    )
  end

  def render("503.html", assigns) do
    render(
      __MODULE__,
      "internal_server_error.html",
      Map.put(assigns, :layout, {KlausurarchivWeb.LayoutView, "error.html"})
    )
  end

  def render("404.html", assigns) do
    render(
      __MODULE__,
      "not_found.html",
      Map.put(assigns, :layout, {KlausurarchivWeb.LayoutView, "error.html"})
    )
  end

  def render("400.html", assigns) do
    render(
      __MODULE__,
      "bad_request.html",
      Map.put(assigns, :layout, {KlausurarchivWeb.LayoutView, "error.html"})
    )
  end
end
