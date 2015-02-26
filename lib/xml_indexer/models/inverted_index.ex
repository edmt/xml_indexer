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
      for {corpus, _tokens} <- documents do
        XmlIndexer.Repo.insert(corpus)
      end
    end)
  end
end

# MyRepo.transaction(fn ->
#   MyRepo.update(%{alice | balance: alice.balance - 10})
#   MyRepo.update(%{bob | balance: bob.balance + 10})
# end)

# # In the following example only the comment will be rolled back
# MyRepo.transaction(fn ->
#   MyRepo.insert(%Post{})

#   MyRepo.transaction(fn ->
#     MyRepo.insert(%Comment{})
#     raise "error"
#   end)
# end)

# # Roll back a transaction explicitly
# MyRepo.transaction(fn ->
#   p = MyRepo.insert(%Post{})
#   if not Editor.post_allowed?(p) do
#     MyRepo.rollback(:posting_not_allowed)
#   end
# end)

# http://hexdocs.pm/ecto/