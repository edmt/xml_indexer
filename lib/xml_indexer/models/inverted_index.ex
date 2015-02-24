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
    XmlIndexer.Repo.all(query)
  end
end
