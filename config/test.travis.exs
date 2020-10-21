use Mix.Config

# Configure your database
config :squadster, Squadster.Repo,
  username: "postgres",
  password: "",
  database: EnvHelper.safe_env("DB_BASE_NAME", "squadster") <> "_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :squadster, SquadsterWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
