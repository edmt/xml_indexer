defmodule XmlIndexer.Polling do
  use GenServer

  ## External API
  def start_link(redis) do
    IO.puts("Starting the polling process... #{inspect self}")
    #redis = Exredis.start_using_connection_string("redis://127.0.0.1:6379")
    #{:ok, redis} = Exredis.start_link('127.0.0.1', 6379, 0, '', :no_reconnect)
    link  = GenServer.start_link(__MODULE__, [redis], name: __MODULE__)
    GenServer.cast __MODULE__, {:loop, redis}
    link
  end


  ## GenServer implementation
  def handle_cast({:loop, redis}, _state) do
    loop(redis)
    { :noreply, [] }
  end

  # Internal API
  defp loop(redis) do
    case redis |> Exredis.query ["RPOP", "foo"] do
      :undefined -> nil
      document -> XmlIndexer.Indexer.index document
    end

    loop(redis)
  end
end
