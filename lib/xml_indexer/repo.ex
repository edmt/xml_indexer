defmodule XmlIndexer.Repo do
  IO.puts("Starting the repo... #{inspect self}")
  use Ecto.Repo, otp_app: :xml_indexer, adapter: Tds.Ecto
end
