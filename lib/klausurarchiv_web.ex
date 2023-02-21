defmodule KlausurarchivWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use KlausurarchivWeb, :controller
      use KlausurarchivWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: KlausurarchivWeb
      import Plug.Conn
      import KlausurarchivWeb.Router.Helpers
      import KlausurarchivWeb.Gettext
      import Phoenix.LiveView.Controller
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/klausurarchiv_web/templates",
        namespace: KlausurarchivWeb

      use Appsignal.Phoenix.View

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import KlausurarchivWeb.Router.Helpers
      import KlausurarchivWeb.ErrorHelpers
      import KlausurarchivWeb.Gettext
      import Phoenix.LiveView.Helpers

      def error_label(changeset, field) do
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              if key == :count do
                String.replace(acc, "%{#{key}}", to_string(value))
              else
                acc
              end
            end)
          end)

        case Enum.find(errors, fn {key, value} -> key == field end) do
          {field, errors} ->
            content_tag(:p, Enum.join(errors, ", "), class: "help is-danger")

          nil ->
            nil
        end
      end

      def get_user(conn) do
        case conn.assigns[:session] do
          nil ->
            nil

          session ->
            Klausurarchiv.Users.get_user(session.user_id)
        end
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import KlausurarchivWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
