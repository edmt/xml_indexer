defmodule XmlIndexer.Supervisor do
  use Supervisor

  def start_link() do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [])
    start_workers(sup)
    result
  end

  def start_workers(sup) do
    # Start the redis client
    {:ok, redis} = Supervisor.start_child(sup, worker(Exredis, Application.get_env(:redis, :server)))
    # Then the rest of the workers
    Supervisor.start_child(sup, worker(XmlIndexer.Indexer, []))
    Supervisor.start_child(sup, worker(XmlIndexer.Polling, [redis]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end