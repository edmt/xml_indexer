defmodule XmlIndexer.Mixfile do
  use Mix.Project

  def project do
    [app: :xml_indexer,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :tds_ecto, :ecto],
     registered: [:xml_indexer],
     mod: {XmlIndexer, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:exredis, github: "artemeff/exredis", tag: "0.1.0"},
      {:tds_ecto, "~> 0.1.4"},
      {:ecto, "~> 0.8.1"}
    ]
  end
end
