use Mix.Config

# Configures the redis client
config :redis,
  server: ['88.198.47.247', 6379, 0, '', :no_reconnect],
  consumer_queue: "xml_index"
