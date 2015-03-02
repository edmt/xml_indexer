defmodule XmlIndexer.Token do
  @stopwords Enum.into(Application.get_env(:stopwords, :spanish), HashSet.new)

  def tokenize(corpus) do
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
end
