use Mix.Config

# Configures the redis client
config :redis,
  server: ['127.0.0.1', 6379, 0, '', :no_reconnect],
  consumer_queue: "xml_index"