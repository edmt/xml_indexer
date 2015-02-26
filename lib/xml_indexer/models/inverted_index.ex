defmodule InvertedIndex do
  use Ecto.Model

  @primary_key false
  schema "invertedIndex" do
    field :token, :string
    field :corpusId, :string
  end
end

defmodule InvertedIndex.Queries do
  import Ecto.Query

  def sample_query do
    query = from i in InvertedIndex,
      limit: 2,
      select: i
    XmlIndexer.Repo.all(query, [timeout: 30000])
  end

  def save(documents) do
    XmlIndexer.Repo.transaction(fn ->
      for {corpus, tokens} <- documents do
        XmlIndexer.Repo.insert(corpus)
        for token <- tokens do
          XmlIndexer.Repo.insert %InvertedIndex{corpusId: corpus.corpusId, token: token}
        end
      end
    end)
  end
end
