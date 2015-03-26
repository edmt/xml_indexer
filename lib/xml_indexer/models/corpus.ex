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
