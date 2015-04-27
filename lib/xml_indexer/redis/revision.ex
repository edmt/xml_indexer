defmodule XmlIndexer.Redis.Revision do
  use GenServer

  require Logger

  ## External API
  def start_link(redis, queue) do
    Logger.debug("Starting the revision process... #{inspect self}")
    GenServer.start_link(__MODULE__, [redis, queue], name: __MODULE__)
  end

  def rev(document) do
    GenServer.cast __MODULE__, {:rev, document}
  end

  ## GenServer implementation
  def handle_cast({:rev, document}, _state) do
    [redis, queue] = _state

    redis |> Exredis.query_pipe [["MULTI"], ["LPUSH", "queue:#{queue}-revision", document], ["LREM", "queue:#{queue}-process", "-1", document], ["EXEC"]]

    { :noreply, _state }
  end
end
