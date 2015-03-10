defmodule XmlIndexer.Indexer do
  use GenServer

  ## External API
  def start_link() do
    IO.puts("Starting the index process... #{inspect self}")
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def index(document) do
    GenServer.cast __MODULE__, {:index, document}
  end

  ## GenServer implementation
  def handle_cast({:index, document}, _state) do
    IO.puts "Indexando... #{inspect document}"

    %{"xml_string" => xml_string, "company_rfc" => rfc} = Poison.Parser.parse!(document)
    { xml, _rest}  = extract(Mix.env, xml_string)
    XmlIndexer.Xml.extract(xml, rfc) |> InvertedIndex.Queries.save
    XmlIndexer.Acknowledge.ack document

    { :noreply, [] }
  end

  defp extract(:prod, document), do: :binary.bin_to_list(document) |> :xmerl_scan.string
  defp extract(:dev, document), do: :xmerl_scan.file(document)
end
