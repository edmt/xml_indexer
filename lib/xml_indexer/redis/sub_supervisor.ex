defmodule XmlIndexer.Redis.SubSupervisor do
  use Supervisor

  require Logger

  def start_link() do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    start_workers(sup)
    result
  end

  def start_workers(sup) do
    Logger.debug("Starting redis workers")
    conf = Application.get_env(:xml_indexer, :redis)
    Logger.debug(inspect conf)
    [host: h, port: p, database: db, password: pwd, reconnect_sleep: rs, consumer_queue: queue] = conf

    # Starting redis client
    case Supervisor.start_child(sup, worker(Exredis, [h, p, db, pwd, rs])) do
      {:ok, redis} ->
        Logger.debug "Parent process: #{inspect redis}"
        Supervisor.start_child(sup, worker(XmlIndexer.Redis.Acknowledge, [redis, queue]))
        Supervisor.start_child(sup, worker(XmlIndexer.Redis.Flush,       [redis, queue]))
        Supervisor.start_child(sup, worker(XmlIndexer.Redis.Polling,     [redis, queue]))
      _ ->
        Logger.error "Connection to redis refused"
    end
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
