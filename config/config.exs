# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cocu,
  ecto_repos: [Cocu.Repo]

# Configures the endpoint1
config :cocu, CocuWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "nj5neEOtPmulS0TvZ2pvvgzOjWitZPtTwCgV9S1vWlTZ3nOlV1lNFWxIPeRReN1D",
  render_errors: [view: CocuWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cocu.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# TODO: Change secret_key to env variable
config :cocu, Cocu.Auth.Guardian,
  verify_module: Guardian.JWT,
  secret_key: System.get_env("GUARDIAN_SECRET") || "OQO+xxJfL+cEJLlFYCzDAEhY+6ufldLN9+W4Q5CwveR/T5byue8HkHntjdmSExWX",
  issuer: "cocu",
  ttl: { 30, :days },
  verify_issuer: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
