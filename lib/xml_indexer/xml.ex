defmodule XmlIndexer.Xml do
  require Record
  Record.defrecord :xmlElement,   Record.extract(:xmlElement,   from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,      Record.extract(:xmlText,      from_lib: "xmerl/include/xmerl.hrl")

  @stopwords Enum.into(Application.get_env(:stopwords, :spanish), HashSet.new)

  def extract(doc) do
    _doc_id = uuid(doc)
    for corpus <- conceptos(doc) do
      desc = descripcion(corpus)
      {
        %Corpus{
          corpusId: corpus_id(_doc_id, corpus),
          corpus: desc,
          unidad: unidad(corpus),
          valorUnitario: valor_unitario(corpus)#,
          #no_identificacion: no_identificacion(corpus)
        },
        tokens: tokenize(desc)
      }
    end
  end


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
  defp large?(token),           do: String.length(token) >= 3
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
    :xmerl_xpath.string(full_expression, doc)
      |> List.first
      |> xmlAttribute(:value)
      |> to_string
  end
end
