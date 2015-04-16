defmodule XmlIndexer.Redis.Acknowledge do
  use GenServer

  require Logger

  ## External API
  def start_link(redis, queue) do
    Logger.debug("Starting the acknowledge process... #{inspect self}")
    GenServer.start_link(__MODULE__, [redis, queue], name: __MODULE__)
  end

  def ack(document) do
    GenServer.cast __MODULE__, {:ack, document}
  end

  ## GenServer implementation
  def handle_cast({:ack, document}, _state) do
    [redis, queue] = _state

    redis |> Exredis.query ["LREM", "queue:#{queue}-process", "-1", document]

    { :noreply, _state }
  end
end
