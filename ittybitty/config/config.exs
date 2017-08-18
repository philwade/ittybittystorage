# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ittybitty,
  ecto_repos: [Ittybitty.Repo]

# Configures the endpoint
config :ittybitty, Ittybitty.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ddBzqGHvTQxhIFFK0HIGD59o2SqewC59cR5j1gH/FHX9gfc74qIaEbdfE19eQF/T",
  render_errors: [view: Ittybitty.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ittybitty.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# configure recaptcha
config :recaptcha,
  public_key: System.get_env("RECAPTCHA_PUBLIC_KEY"),
  secret: System.get_env("RECAPTCHA_PRIVATE_KEY")

config :ittybitty, :recaptcha_api, Recaptcha

config :ittybitty,
  redis_uri: System.get_env("REDIS_URI")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
