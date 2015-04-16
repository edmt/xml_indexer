use Mix.Config

# Configures the redis client
config :xml_indexer, :redis,
  host: "redis.dev",
  port: 6379,
  database: 0,
  password: "",
  reconnect_sleep: :no_reconnect,
  consumer_queue: "xml_index"

config :xml_indexer, XmlIndexer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "fm_services_dev",
  hostname: "postgres.dev"
