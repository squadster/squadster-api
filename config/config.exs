use Mix.Config

config :squadster,
  ecto_repos: [Squadster.Repo],
  frontend_url: System.get_env("FRONTEND_URL")

# Configures the endpoint
config :squadster, SquadsterWeb.Endpoint,
  url: [host: System.get_env("HOSTNAME") || "squadster.wtf"],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "YwHUkFneakAZRdSvutrJqpOZZ2kogjIFMsZntnRE89BibSBDUDc+SjBnABMMcZhCTiJTLuY9JdYOsCtZ7DcX3VZ",
  render_errors: [view: SquadsterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Squadster.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "oauth.exs"
import_config "scheduler.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
