defmodule XmlIndexer.Mixfile do
  use Mix.Project

  def project do
    [app: :xml_indexer,
     version: "1.0.6",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:postgrex, :decimal, :poolboy, :ecto, :exredis, :eredis, :poison, :xmerl],
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
      {:exredis, "~> 0.1.1"},
      {:postgrex, "~> 0.8.1"},
      {:ecto, "~> 0.10.2"},
      {:poison, "~> 1.3.1" },
      {:exrm, "~> 0.15.3"}
    ]
  end
end
