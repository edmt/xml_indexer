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
    document
      |> parse_json
      |> parse_message(document)
      |> parse_xml(document)
      |> process_xml
      |> save_to_database(document)
    { :noreply, [] }
  end

  defp parse_json(document) do
    case Poison.Parser.parse(document) do
      {:ok, message} -> {:ok, message}
      error ->
        Logger.debug "Not a valid json document #{inspect document}. It will be removed."
        XmlIndexer.Redis.Acknowledge.ack document
        error
    end
  end

  defp parse_message(message, doc) do
    case message do
      {:ok, %{"ticket_id" => id, "xml_string" => _, "company_rfc" => _, "owner_rfc" => _, "created_at" => _}} when is_integer(id) ->
        message
      {:ok, %{"ticket_id" => %{"ticket_id" => id}, "xml_string" => xs, "company_rfc" => company, "owner_rfc" => owner, "created_at" => _created_at}} ->
        {:ok, %{"ticket_id" => id, "xml_string" => xs, "company_rfc" => company, "owner_rfc" => owner, "created_at" => _created_at}}
      error ->
        Logger.debug "Not a valid message. It cannot be indexed. It will be removed. Message: #{inspect doc}"
        XmlIndexer.Redis.Acknowledge.ack doc
        error
    end
  end

  defp parse_xml(message, doc) do
    case message do
      {:ok, m} ->
        try do
          {:ok, xml} = Map.fetch(m, "xml_string")
          {:ok, :xmerl_scan.string(:binary.bin_to_list(xml)), Map.drop(m, ["xml_string"]) }
        catch
          :exit, reason ->
            Logger.debug "It cannot parse xml document. It will be moved to an error queue."
            XmlIndexer.Redis.Revision.rev doc
            {:error, reason}
        end
      error -> error
    end
  end

  defp process_xml(tuple) do
    case tuple do
      {:ok, {xml, _rest}, metadata} ->
        {:ok, XmlIndexer.Xml.extract(xml, metadata)}
      error -> error
    end
  end

  defp save_to_database(corpuses, doc) do
    try do
      # If it fails for whatever reason, it will not be acknowledged, so the next time it will be reprocessed
      case corpuses do
        {:ok, c} ->
          Corpus.Query.save_all c
          XmlIndexer.Redis.Acknowledge.ack doc
        _ -> nil
      end
    rescue
      e in Postgrex.Error ->
        # But in case of a unique violation, it will be removed...
        case e do
          %Postgrex.Error{postgres: %{code: code}} when code === :unique_violation ->
            Logger.debug "Removing duplicate document. It is already in database..."
            XmlIndexer.Redis.Acknowledge.ack doc
          _ ->
            Logger.debug "Weird error. What can I do?"
        end
    end
  end
end
