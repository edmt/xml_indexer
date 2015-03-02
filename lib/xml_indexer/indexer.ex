defmodule XmlIndexer.Indexer do
  use GenServer
  require Record

  Record.defrecord :xmlElement,   Record.extract(:xmlElement,   from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,      Record.extract(:xmlText,      from_lib: "xmerl/include/xmerl.hrl")

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
    #InvertedIndex.Queries.save
    XmlIndexer.Xml.extract(xml, rfc)
    { :noreply, [] }
  end
end
