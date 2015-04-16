defmodule XmlIndexer.Xml.Parser do
  use Behaviour

  defcallback extract(Tuple.t, Keyword.t) :: [Tuple.t]
end
