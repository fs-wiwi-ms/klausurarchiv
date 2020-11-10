defmodule Klausurarchiv.Mixfile do
  use Mix.Project

  def project do
    [
      app: :klausurarchiv,
      version: "0.0.1",
      elixir: "~> 1.10.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Klausurarchiv.Application, []},
      extra_applications: [:logger, :runtime_tools, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_slime, "~> 0.13.0"},
      {:phoenix_ecto, "~> 4.2.1"},
      {:plug_cowboy, "~> 2.3"},
      {:postgrex, "~> 0.15"},
      {:distillery, "~> 2.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.18"},
      {:cowboy, "~> 2.8.0"},
      {:ecto_enum, "~> 1.2"},
      {:httpoison, "~> 1.7"},
      {:sentry, "~> 8.0"},
      {:jason, "~> 1.2"},
      {:plug_preferred_locales, "~> 0.1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      ci: ["deps.get", "test"]
    ]
  end
end
