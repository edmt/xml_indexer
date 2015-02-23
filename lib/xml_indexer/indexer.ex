# https://code.google.com/p/erlang/source/browse/trunk/lib/xmerl/include/xmerl.hrl?r=160
# http://elixir-lang.org/docs/stable/elixir/Record.html
# http://isotope11.com/blog/parsing-xml-using-elixir
# Convert a record to a keyword list
# user(record) #=> [name: "meg", age: 26]

defmodule XmlIndexer.Indexer do
  require Record
  Record.defrecord :xmlElement,   Record.extract(:xmlElement,   from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,      Record.extract(:xmlText,      from_lib: "xmerl/include/xmerl.hrl")

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
    IO.puts "Diciendo hola... #{inspect document}"

    { document, _rest} = :xmerl_scan.file(document)
    XmlIndexer.Xml.test(document)
    { :noreply, [] }
  end
end
