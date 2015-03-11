defmodule XmlIndexer.Supervisor do
  use Supervisor

  def start_link() do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [])
    start_workers(sup)
    result
  end

  def start_workers(sup) do
    Supervisor.start_child(sup, supervisor(XmlIndexer.Redis.SubSupervisor, []))
    Supervisor.start_child(sup, worker(XmlIndexer.Repo, []))
    Supervisor.start_child(sup, worker(XmlIndexer.Indexer, []))
  end

  def init(_) do
    supervise [], strategy: :one_for_one, max_restarts: 50, max_seconds: 5
  end
end
