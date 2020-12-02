defmodule Squadster.MixProject do
  use Mix.Project

  def project do
    [
      app: :squadster,
      version: "0.1.0",
      elixir: "~> 1.9.4", # OTP > 20
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: [
        espec: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      releases: [
        squadster: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ],
      default_release: 'squadster',
      test_coverage: [tool: ExCoveralls, test_task: "espec"]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Squadster.Application, []},
      extra_applications: [:logger, :runtime_tools, :ueberauth_vk, :absinthe_plug, :ex_machina, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "spec/support"]
  defp elixirc_paths(:dev), do: ["lib", "spec/support/factory", "spec/support/factory.ex"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.6"},
      {:phoenix_pubsub, "~> 2.0.0"},
      {:phoenix_ecto, "~> 4.2.1"},
      {:ecto_sql, "~> 3.5.1"},
      {:postgrex, ">= 0.15.7"},
      {:gettext, "~> 0.18.2"},
      {:jason, "~> 1.2.2"},
      {:plug_cowboy, "~> 2.4.0"},
      {:poison, "~> 4.0.1"},
      {:ueberauth_vk, git: "https://github.com/ueberauth/ueberauth_vk.git", branch: :master}, # TODO: need to set it back to 0.4.0 when it will be released
      {:absinthe, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4.0"},
      {:cors_plug, "~> 2.0.2"},
      {:ecto_enum, "~> 1.4"},
      {:faker, "~> 0.16.0"},
      {:dataloader, "~> 1.0.8"},
      {:timex, "~> 3.6.2"},
      {:quantum, "~> 3.3.0"},
      {:ex_machina, "~> 2.4.0"},
      {:httpoison, "~> 1.7.0"},
      {:mockery, "~> 2.3.1", runtime: false},
      {:excoveralls, "~> 0.11.1"},

      {:phoenix_live_reload, "~> 1.2.4", only: :dev},

      {:espec, "~> 1.8.2", only: :test},
      {:espec_phoenix, "~> 0.7.1", only: :test},
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
      "ecto.migrate": ["ecto.migrate", "ecto.dump"],
      "ecto.seed": ["run priv/repo/seeds.#{Mix.env()}.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
