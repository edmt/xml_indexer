defmodule XmlIndexer.Xml do
  require Logger

  def extract(xml, rfc, options) do
    strategy(rfc).extract(xml, options)
  end

  defp strategy(rfc) do
    case Application.get_env(:particular_treatment, rfc |> String.upcase |> String.to_atom) do
      nil ->
        Logger.debug("Using default parser for #{rfc}")
        XmlIndexer.Xml.Parser.Default
      module ->
        Logger.debug("Using particular parser (#{inspect module}) for #{rfc}")
        module
    end
  end
end
