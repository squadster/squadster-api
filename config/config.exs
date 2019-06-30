# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :squadster,
  ecto_repos: [Squadster.Repo]

# Configures the endpoint
config :squadster, SquadsterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3EpslvV8zh+QGjzuHhfBLEUuHVFp9HPrrmGyIFU8/TiJTLuY9JdYOsCtZ7DcX3VZ",
  render_errors: [view: SquadsterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Squadster.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
