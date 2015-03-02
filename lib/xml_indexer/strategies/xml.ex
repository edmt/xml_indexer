defmodule XmlIndexer.Xml do
  def extract(xml, rfc) do    
    IO.inspect strategy(rfc).extract(xml)
  end

  defp strategy(rfc) do
    case Application.get_env(:particular_treatment, rfc) do
      nil -> XmlIndexer.Xml.Parser.Default
      module -> module
    end
  end
end
