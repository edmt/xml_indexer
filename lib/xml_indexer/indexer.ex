defmodule XmlIndexer.Indexer do
  use GenServer

  require Logger

  ## External API
  def start_link() do
    Logger.debug("Starting the index process... #{inspect self}")
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def index(document) do
    GenServer.cast __MODULE__, {:index, document}
  end

  ## GenServer implementation
  def handle_cast({:index, document}, _state) do
    case Poison.Parser.parse(document) do
      {:ok, %{"xml_string" => xml_string, "company_rfc" => rfc, "ticket_id" => ticket_id, "created_at" => _created_at}} when is_integer(ticket_id) ->

        Logger.debug "Indexing ticket: #{ticket_id}, company_rfc: #{rfc}"
        { xml, _rest}  = extract(xml_string)

        try do
          # Extracts xml data and tries to save it
          XmlIndexer.Xml.extract(xml, rfc, [ticket_id: ticket_id]) |> Corpus.Query.save_all
          # If it fails, it will not be acknowledged, so the next time it will be reprocessed
          XmlIndexer.Redis.Acknowledge.ack document
        rescue
          e in Postgrex.Error ->
            # Also, in case of a unique violation, it will be removed...
            case e do
              %Postgrex.Error{postgres: %{code: code}} when code === :unique_violation ->
                Logger.debug "Removing duplicate document. It is already in database..."
                XmlIndexer.Redis.Acknowledge.ack document
              _ ->
                Logger.debug "Weird error. What can I do?"
            end
        end
      _ ->
        Logger.debug "Not a valid document #{inspect document}"
        XmlIndexer.Redis.Acknowledge.ack document
    end

    { :noreply, [] }
  end

  defp extract(document), do: :binary.bin_to_list(document) |> :xmerl_scan.string
end
