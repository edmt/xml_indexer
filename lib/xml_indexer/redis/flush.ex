defmodule XmlIndexer.Redis.Flush do
  use GenServer

  require Logger

  @ms       1
  @second   1000 * @ms
  @minute   60 * @second
  @interval  5 * @minute

  ## External API
  def start_link(redis, queue) do
    Logger.debug("Starting the flush process... #{inspect self}")
    GenServer.start_link(__MODULE__, [redis, queue], name: __MODULE__)
  end

  ## GenServer implementation
  def handle_info(:tick, _state) do
    [redis, queue] = _state
    current_time   = :calendar.universal_time
    documents = redis |> Exredis.query ["LRANGE", "queue:#{queue}-process", "0", "-1"]
    Logger.debug("Flushing process is running. Requeueing #{Enum.count(documents)} documents.")

    for doc <- documents do
      %{"created_at" => timestamp} = Poison.Parser.parse!(doc)
      {_days, {_hours, _minutes, _seconds}} = :calendar.time_difference timestamp_to_datetime(timestamp), current_time

      case _minutes > 5 do
        true ->
          redis |> Exredis.query_pipe [["MULTI"], ["LREM", "queue:#{queue}-process", "-1", doc], ["LPUSH", "queue:#{queue}", doc], ["EXEC"]]
        _ -> nil
      end
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
