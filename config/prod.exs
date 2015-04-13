use Mix.Config

# Configures the redis client
config :redis,
  server: ['redis.prod', 6379, 0, '', :no_reconnect],
  consumer_queue: "xml_index"

config :xml_indexer, XmlIndexer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "facturame-development",
  password: "facturame-development",
  database: "facturame-development",
  hostname: "postgres.prod"
