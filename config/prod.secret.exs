use Mix.Config

config :squadster, Squadster.Repo,
  # ssl: true,
  url: EnvHelper.safe_env("DATABASE_URL"),
  pool_size: String.to_integer(EnvHelper.safe_env("POOL_SIZE", "10", false)

config :squadster, SquadsterWeb.Endpoint,
  http: [:inet6, port: String.to_integer(EnvHelper.safe_env("PORT", "4000", false)],
  secret_key_base: EnvHelper.safe_env("SECRET_KEY_BASE")
