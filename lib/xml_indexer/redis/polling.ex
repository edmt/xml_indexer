defmodule XmlIndexer.Redis.Polling do
  use GenServer

  ## External API
  def start_link(redis, queue) do
    IO.puts("Starting the polling process... #{inspect self}")
    link  = GenServer.start_link(__MODULE__, [redis, queue], name: __MODULE__)
    GenServer.cast __MODULE__, {:loop, redis, queue}
    link
  end


  ## GenServer implementation
  def handle_cast({:loop, redis, queue}, _state) do
    loop(redis, queue)
    { :noreply, [] }
  end

  # Internal API
  defp loop(redis, queue) do
    case redis |> Exredis.query ["RPOPLPUSH", "queue:#{queue}", "queue:#{queue}-process"] do
      :undefined -> nil
      document -> XmlIndexer.Indexer.index document
    end

    loop(redis, queue)
  end
end
