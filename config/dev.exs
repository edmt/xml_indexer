use Mix.Config

# Configures the redis client
config :xml_indexer, :redis,
  host: "redis.dev",
  port: 6380,
  database: 0,
  password: "",
  reconnect_sleep: :no_reconnect,
  consumer_queue: "xml_index"

config :xml_indexer, XmlIndexer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "facturame-development",
  password: "facturame-development",
  database: "facturame-development",
  hostname: "postgres.dev"
