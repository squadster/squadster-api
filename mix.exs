defmodule Squadster.MixProject do
  use Mix.Project

  def project do
    [
      app: :squadster,
      version: "0.1.0",
      elixir: "~> 1.9.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        squadster: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ],
      default_release: 'squadster'
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Squadster.Application, []},
      extra_applications: [:logger, :runtime_tools, :ueberauth_vk, :absinthe_plug]
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
      {:phoenix, "~> 1.4.7"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:ueberauth_vk, "~> 0.3"},
      {:absinthe, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4.0"},
      {:cors_plug, "~> 2.0"},
      {:ecto_enum, "~> 1.4"},
      {:faker, "~> 0.13"},
      {:dataloader, "~> 1.0.0"},
      {:timex, "~> 3.5"},

      {:phoenix_live_reload, "~> 1.2", only: :dev},
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
      "ecto.seed": ["run priv/repo/seeds.#{Mix.env()}.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
