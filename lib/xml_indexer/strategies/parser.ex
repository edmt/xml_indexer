defmodule XmlIndexer.Xml.Parser do
  use Behaviour

  defcallback parse(String.t) :: any
  defcallback extensions() :: [String.t]

  ## Text manipulation
  defp tokenize(corpus) do
    for token <- Regex.split(~r/\s/, corpus), valid?(token), do: String.downcase token
  end

  defp valid?(token) do
    large?(token) &&
      !has_digits?(token) &&
      !has_punctuation?(token) &&
      !stopword?(token)
  end
  defp stopword?(token),        do: Set.member?(@stopwords, token)
  defp large?(token),           do: String.length(token) > 3
  defp has_digits?(token),      do: Regex.match?(~r/[[:digit:]]/, token)
  defp has_punctuation?(token), do: Regex.match?(~r/[[:punct:]]/, token)


  ## Xml manipulation
  defp no_identificacion(corpus),  do: attr(corpus, "//cfdi:Concepto", "noIdentificacion")
  defp valor_unitario(corpus)      do
    {float, _} = Float.parse attr(corpus, "//cfdi:Concepto", "valorUnitario")
    float
  end
  defp unidad(corpus),             do: attr(corpus, "//cfdi:Concepto", "unidad")
  defp descripcion(corpus),        do: attr(corpus, "//cfdi:Concepto", "descripcion")
  defp corpus_id(_doc_id, corpus), do: _doc_id <> "_" <> to_string(xmlElement(corpus, :pos))
  defp conceptos(doc),             do: :xmerl_xpath.string('//cfdi:Concepto', doc)
  defp uuid(doc),                  do: attr(doc, "//tfd:TimbreFiscalDigital", "UUID")

  defp attr(doc, xpath, attribute) do
    full_expression = to_char_list(xpath <> "/@" <> attribute)
    nodes = :xmerl_xpath.string(full_expression, doc)
    case nodes do
      [] -> nil
      [attribute] -> xmlAttribute(attribute, :value) |> to_string
    end
  end
end
