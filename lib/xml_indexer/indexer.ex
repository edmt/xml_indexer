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

    %{"path" => filepath, "company_rfc" => rfc} = Poison.Parser.parse!(document)
    { xml, _rest} = :xmerl_scan.file(filepath)
    XmlIndexer.Xml.extract(xml, rfc) |> InvertedIndex.Queries.save
    { :noreply, [] }
  end
end
