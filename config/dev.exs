use Mix.Config

# Configures the redis client
config :redis,
  server: ['redis.dev', 6379, 0, '', :no_reconnect],
  consumer_queue: "xml_index"

config :xml_indexer, XmlIndexer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "fm_services_dev",
  hostname: "postgres.dev"
