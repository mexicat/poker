# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :frontend, FrontendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pz5hTigV6q3+DKOkn367v6TgzPFK+bJtICkqePKtblD3m9uf+YqBlBBRiN3o1mg5",
  render_errors: [view: FrontendWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Frontend.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "DdGcEyNtX2U4ZGT5EQprMiGikkjsJ2Wt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
