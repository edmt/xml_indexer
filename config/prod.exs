use Mix.Config

# Configures the redis client
config :xml_indexer, :redis,
  host: "redis.prod",
  port: 6379,
  database: 0,
  password: "",
  reconnect_sleep: 5000,
  consumer_queue: "xml_index"

config :xml_indexer, XmlIndexer.Repo,
  adapter: Ecto.Adapters.Postgres,
  timeout: 10000,
  username: "facturame-production",
  password: "facturame-production",
  database: "facturame-production",
  hostname: "postgres.prod"
