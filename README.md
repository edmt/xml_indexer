## XmlIndexer

Consumidor[^1] que indexa tickets para propósitos de búsqueda

## Motivación
> As much as possible, we needed to isolate each consumer from the source of the data. They should ideally integrate with just a single data repository that would give them access to everything.

> The idea is that adding a new data system—be it a data source or a data destination—should create integration work only to connect it to a single pipeline instead of each consumer of data.

> ![alt text](http://engineering.linkedin.com/sites/default/files/pipeline_ownership.png "Diagrama")

> [The Log: What every software engineer should know about real-time data's unifying abstraction](http://engineering.linkedin.com/distributed-systems/log-what-every-software-engineer-should-know-about-real-time-datas-unifying "The Log")

XmlIndexer usa [PostgreSQL](https://www.postgresql.org "PostgreSQL") para el almacenamiento interno de la estructura de búsqueda, y [Redis](http://redis.io/) (Poor Man's Apache Kafka).

## Requerimientos

- Probado con la última versión de Elixir (1.0.3).

- Redis 2.4.10 o superior.

- PostgreSQL 9.4.1 o superior.

## Instalación

Es necesario modificar la resolución *DNS* para incluir las direcciones

- redis.dev
- postgres.dev

en desarrollo. O

- redis.prod
- postgres.prod

en un ambiente de producción.

La manera más sencilla es especificar manualmente las direcciones en el archivo */etc/hosts*.

## Primeros pasos

1. [Escribiendo en redis](#escribiendo-en-redis)
2. [Arrancando XmlIndexer](#arrancando-xmlindexer)
3. Listo

#### Escribiendo en redis

Se espera una estructura como:

```
struct Payload {
  1: i32 ticket_id,
  2: string xml_string,
  3: string company_rfc,
  4: string owner_rfc,
  5: i32 created_at
}
```

que debe ser serializada en formato JSON, y ser añadida a la lista en redis ***queue:xml_index***.

Pseudocódigo:

```ruby
payload = {
  id:          1,
  xml_string:  "<xml>...</xml>",
  company_rfc: "AAA010101AAA",
  owner_rfc:   "XYZ999999ZYX",
  created_at:  Time.now.to_i
}

queue = "xml_index"
serialized_payload = JSON.encode(payload)

redis.multi do
  redis.sadd "queues", queue
  redis.lpush "queue:#{queue}", serialized_payload
end
```

#### Arrancando XmlIndexer

Las instancias de Redis y PostgreSQL especifidadas en la configuración deben estar corriendo, de lo contrario XmlIndexer no podrá iniciar.

Para desarrollo es suficiente con iniciar una sesión con *iex*.

```bash
iex -S mix
```

## Aquí falta algo...

Si hay algo que necesites o quieras saber, por favor contacta a [Daniel Martínez](mailto:daniel.martinez@diverza.com "Sobre XmlIndexer...") o abre un nuevo Issue.

[^1]: https://kafka.apache.org/documentation.html#theconsumer
