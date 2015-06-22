defmodule XmlIndexer.Xml.Parser.Soriana do
  @behaviour XmlIndexer.Xml.Parser

  require Record
  Record.defrecord :xmlElement,   Record.extract(:xmlElement,   from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,      Record.extract(:xmlText,      from_lib: "xmerl/include/xmerl.hrl")

  def extract(doc, options) do
    _doc_id   = uuid(doc)
    _emisor   = emisor_rfc(doc)
    _receptor = receptor_rfc(doc)

    for corpus <- conceptos(doc) do
      desc = descripcion(corpus)
      %Corpus{
        ticketId: Map.get(options, "ticket_id"),
        receiptId: Map.get(options, "receipt_id"),
        corpusId: corpus_id(_doc_id, corpus),
        corpus: desc,
        unidad: unidad(corpus),
        valorUnitario: valor_unitario(corpus),
        noIdentificacion: no_identificacion(corpus),
        emisor: _emisor,
        receptor: _receptor,
        created_at: Ecto.DateTime.utc
      }
    end
  end

  # ## Xml manipulation
  defp no_identificacion(corpus),  do: text(corpus, "sor:Cve_upc")

  defp valor_unitario(corpus)      do
    {float, _} = Float.parse text(corpus, "sor:Imp_PrecNeto")
    float
  end

  defp unidad(corpus),             do: text(corpus, "sor:Desc_UniMed")

  defp corpus_id(_doc_id, corpus), do: _doc_id <> "_" <> to_string(xmlElement(corpus, :pos))

  defp descripcion(corpus),        do: text(corpus, "//sor:Desc_upc")

  defp conceptos(doc),             do: :xmerl_xpath.string('//sor:ftFEDet', doc)

  defp uuid(doc),                  do: attr(doc, "//tfd:TimbreFiscalDigital", "UUID")

  defp emisor_rfc(doc),            do: attr(doc, "//cfdi:Emisor", "rfc")

  defp receptor_rfc(doc),          do: attr(doc, "//cfdi:Receptor", "rfc")

  defp attr(doc, xpath, attribute) do
    full_expression = to_char_list(xpath <> "/@" <> attribute)
    nodes = :xmerl_xpath.string(full_expression, doc)
    case nodes do
      [] -> nil
      [attribute] -> xmlAttribute(attribute, :value) |> to_string
    end
  end

  defp text(doc, xpath) do
    full_expression = to_char_list(xpath <> "/text()")
    nodes = :xmerl_xpath.string(full_expression, doc)
    case nodes do
      [] -> nil
      [node] -> xmlText(node, :value) |> to_string |> String.strip
    end
  end

end
