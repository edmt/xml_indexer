use Mix.Config

# Configures the redis client
config :redis,
  server: ['redis.prod', 6379, 0, '', :no_reconnect],
  consumer_queue: "xml_index"

config :xml_indexer, XmlIndexer.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "my_app",
  hostname: "postgres.prod"
