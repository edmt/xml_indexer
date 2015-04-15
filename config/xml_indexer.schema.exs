[
  mappings: [
    "particular_treatment.TSO991022PB6": [
      doc: "Provide documentation for particular_treatment.TSO991022PB6 here.",
      to: "particular_treatment.TSO991022PB6",
      datatype: :atom,
      default: XmlIndexer.Xml.Parser.Soriana
    ],
    "xml_indexer.redis.host": [
      doc: "Provide documentation for xml_indexer.redis.host here.",
      to: "xml_indexer.redis.host",
      datatype: :binary,
      default: "redis.dev"
    ],
    "xml_indexer.redis.port": [
      doc: "Provide documentation for xml_indexer.redis.port here.",
      to: "xml_indexer.redis.port",
      datatype: :integer,
      default: 6379
    ],
    "xml_indexer.redis.database": [
      doc: "Provide documentation for xml_indexer.redis.database here.",
      to: "xml_indexer.redis.database",
      datatype: :integer,
      default: 0
    ],
    "xml_indexer.redis.password": [
      doc: "Provide documentation for xml_indexer.redis.password here.",
      to: "xml_indexer.redis.password",
      datatype: :binary,
      default: ""
    ],
    "xml_indexer.redis.reconnect_sleep": [
      doc: "Provide documentation for xml_indexer.redis.reconnect_sleep here.",
      to: "xml_indexer.redis.reconnect_sleep",
      datatype: :atom,
      default: :no_reconnect
    ],
    "xml_indexer.redis.consumer_queue": [
      doc: "Provide documentation for xml_indexer.redis.consumer_queue here.",
      to: "xml_indexer.redis.consumer_queue",
      datatype: :binary,
      default: "xml_index"
    ],
    "xml_indexer.Elixir.XmlIndexer.Repo.adapter": [
      doc: "Provide documentation for xml_indexer.Elixir.XmlIndexer.Repo.adapter here.",
      to: "xml_indexer.Elixir.XmlIndexer.Repo.adapter",
      datatype: :atom,
      default: Ecto.Adapters.Postgres
    ],
    "xml_indexer.Elixir.XmlIndexer.Repo.username": [
      doc: "Provide documentation for xml_indexer.Elixir.XmlIndexer.Repo.username here.",
      to: "xml_indexer.Elixir.XmlIndexer.Repo.username",
      datatype: :binary,
      default: "postgres"
    ],
    "xml_indexer.Elixir.XmlIndexer.Repo.password": [
      doc: "Provide documentation for xml_indexer.Elixir.XmlIndexer.Repo.password here.",
      to: "xml_indexer.Elixir.XmlIndexer.Repo.password",
      datatype: :binary,
      default: "postgres"
    ],
    "xml_indexer.Elixir.XmlIndexer.Repo.database": [
      doc: "Provide documentation for xml_indexer.Elixir.XmlIndexer.Repo.database here.",
      to: "xml_indexer.Elixir.XmlIndexer.Repo.database",
      datatype: :binary,
      default: "fm_services_dev"
    ],
    "xml_indexer.Elixir.XmlIndexer.Repo.hostname": [
      doc: "Provide documentation for xml_indexer.Elixir.XmlIndexer.Repo.hostname here.",
      to: "xml_indexer.Elixir.XmlIndexer.Repo.hostname",
      datatype: :binary,
      default: "postgres.dev"
    ]
  ],
  translations: [
  ]
]