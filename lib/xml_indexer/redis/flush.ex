defmodule XmlIndexer.Redis.Flush do
  use GenServer

  require Logger

  @ms       1
  @second   1000 * @ms
  @minute   60 * @second
  @interval  30 * @second

  ## External API
  def start_link(redis, queue) do
    Logger.debug("Starting the flush process... #{inspect self}")
    GenServer.start_link(__MODULE__, [redis, queue], name: __MODULE__)
  end

  ## GenServer implementation
  def handle_info(:tick, _state) do
    [redis, queue] = _state
    current_time   = :calendar.universal_time
    documents      = redis |> Exredis.query ["LLEN", "queue:#{queue}-process"]

    Logger.debug("Flushing process is running. Requeueing #{documents} documents.")

    for _ <- 0..String.to_integer(documents) do
      redis |> Exredis.query ["RPOPLPUSH", "queue:#{queue}-process", "queue:#{queue}"]
    end

    :erlang.send_after(@interval, __MODULE__, :tick)
    { :noreply, _state }
  end

  def init(_state) do
    send(__MODULE__, :tick)
    {:ok, _state}
  end

  ## Internal functions
  defp timestamp_to_datetime(timestamp) do
    :calendar.gregorian_seconds_to_datetime (timestamp + 719528 * 24 * 3600)
  end
end
