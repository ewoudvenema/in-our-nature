use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
# Enabled to use Wallaby
config :cocu, CocuWeb.Endpoint,
  http: [port: 4001],
  server: true,
  code_reloader: false

config :cocu, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
if System.get_env("TEST_DB_PASS") do
  config :cocu,
         stripe_secret_key: System.get_env("STRIPE_SECRET_KEY")

  config :stripity_stripe, secret_key: System.get_env("STRIPE_SECRET_KEY")
  config :stripity_stripe, platform_client_id: System.get_env("STRIPE_PLATFORM_CLIENT_ID")

  config :cocu, Cocu.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "cocu",
    password: System.get_env("TEST_DB_PASS"),
    database: "cocu_test",
    hostname: "cocu-test.cd4c4pieuyih.eu-central-1.rds.amazonaws.com",
    ssl: true,
    pool: Ecto.Adapters.SQL.Sandbox,
    pool_size: Ecto.Adapters.SQL.Sandbox,
    timeout: 30_000

  config :ex_aws,
    access_key_id: System.get_env("S3_ACCESS_KEY"),
    secret_access_key: System.get_env("S3_SECRET_KEY"),
    region: "eu-central-1",
    host: "s3.eu-central-1.amazonaws.com",
    s3: [
      scheme: "https://",
      host: "s3.eu-central-1.amazonaws.com",
      region: "eu-central-1"
    ]
else
  import_config "test.secret.exs"
end
