defmodule XmlIndexer.Xml do
  require Logger

  def extract(xml, options) do
    strategy(options).extract(xml, options)
  end

  defp strategy(options) do
    {:ok, rfc} = Map.fetch(options, "company_rfc")
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
