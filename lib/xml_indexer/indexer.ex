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
      {:ok, %{"xml_string" => xml_string, "company_rfc" => rfc, "ticket_id" => ticket_id, "created_at" => _created_at}} ->

        Logger.debug "Indexando ticket: #{ticket_id}, company_rfc: #{rfc}"
        { xml, _rest}  = extract(Mix.env, xml_string)
        XmlIndexer.Xml.extract(xml, rfc, [ticket_id: ticket_id]) |> Corpus.Query.save_all
        XmlIndexer.Redis.Acknowledge.ack document

      _ ->
        Logger.debug "Not a valid document #{inspect document}"
        XmlIndexer.Redis.Acknowledge.ack document
    end

    { :noreply, [] }
  end

  defp extract(:prod, document), do: :binary.bin_to_list(document) |> :xmerl_scan.string
  defp extract(:dev, document), do: :xmerl_scan.file(document)
end
