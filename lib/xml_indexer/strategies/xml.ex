defmodule XmlIndexer.Xml do
  def extract(xml, rfc) do    
    strategy(rfc).extract(xml)
  end

  defp strategy(rfc) do
    case Application.get_env(:particular_treatment, rfc |> String.upcase |> String.to_atom) do
      nil -> XmlIndexer.Xml.Parser.Default
      module -> module
    end
  end
end
