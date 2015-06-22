defmodule Corpus do
  use Ecto.Model

  @primary_key false
  schema "corpus" do
    field :ticketId,         :integer
    field :receiptId,        :integer
    field :corpusId,         :string
    field :corpus,           :string
    field :unidad,           :string
    field :noIdentificacion, :string
    field :valorUnitario,    :float
    field :emisor,           :string
    field :receptor,         :string
    field :created_at,       Ecto.DateTime
  end
end

defmodule Corpus.Query do
  def save_all(documents) do
    XmlIndexer.Repo.transaction(fn ->
      for corpus <- documents, do: XmlIndexer.Repo.insert(corpus)
    end)
  end
end
