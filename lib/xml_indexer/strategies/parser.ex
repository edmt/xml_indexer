defmodule XmlIndexer.Xml.Parser do
  use Behaviour

  defcallback extract(Tuple.t) :: [Tuple.t]
end
