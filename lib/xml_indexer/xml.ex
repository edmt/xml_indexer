defmodule XmlIndexer.Xml do
  require Record
  Record.defrecord :xmlElement,   Record.extract(:xmlElement,   from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,      Record.extract(:xmlText,      from_lib: "xmerl/include/xmerl.hrl")

  @stopwords Enum.into(Application.get_env(:stopwords, :spanish), HashSet.new)

  def test(doc) do
    _doc_id = uuid(doc)
    for corpus <- conceptos(doc) do
      IO.inspect %{
        id: corpus_id(_doc_id, corpus),
        descripcion: descripcion(corpus),
        unidad: unidad(corpus),
        valor_unitario: valor_unitario(corpus),
        no_identificacion: no_identificacion(corpus)
      }
      tokenize(descripcion(corpus))      
    end
  end


  ## Text manipulation
  defp tokenize(corpus) do
    tokens = for token <- Regex.split(~r/\s/, corpus), valid?(token), do: String.downcase token
    IO.inspect tokens
  end

  defp valid?(token) do
    large?(token) &&
      !has_digits?(token) &&
      !has_punctuation?(token) &&
      !stopword?(token)
  end

  defp stopword?(token),        do: Set.member?(@stopwords, token)
  defp large?(token),           do: String.length(token) >= 3
  defp has_digits?(token),      do: Regex.match?(~r/[[:digit:]]/, token)
  defp has_punctuation?(token), do: Regex.match?(~r/[[:punct:]]/, token)


  ## Xml manipulation
  defp no_identificacion(corpus),  do: attr(corpus, "//cfdi:Concepto", "noIdentificacion")
  defp valor_unitario(corpus),     do: attr(corpus, "//cfdi:Concepto", "valorUnitario")
  defp unidad(corpus),             do: attr(corpus, "//cfdi:Concepto", "unidad")
  defp descripcion(corpus),        do: attr(corpus, "//cfdi:Concepto", "descripcion")
  defp corpus_id(_doc_id, corpus), do: _doc_id <> "_" <> to_string(xmlElement(corpus, :pos))
  defp conceptos(doc),             do: :xmerl_xpath.string('//cfdi:Concepto', doc)
  defp uuid(doc),                  do: attr(doc, "//tfd:TimbreFiscalDigital", "UUID")

  defp attr(doc, xpath, attribute) do
    full_expression = to_char_list(xpath <> "/@" <> attribute)
    :xmerl_xpath.string(full_expression, doc)
      |> List.first
      |> xmlAttribute(:value)
      |> to_string
  end
end
