defmodule Corpus do
  use Ecto.Model

  @primary_key false
  schema "corpus" do
    field :corpusId,         :string
    field :corpus,           :string
    field :unidad,           :string
    field :noIdentificacion, :string
    field :valorUnitario,    :float
    field :emisor,           :string
    field :receptor,         :string
  end
end

defmodule Corpus.Query do
  import Ecto.Query

  def save_all(documents) do
    XmlIndexer.Repo.transaction(fn ->
      for corpus <- documents, do: XmlIndexer.Repo.insert(corpus)
    end)
  end
end
