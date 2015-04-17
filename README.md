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

La manera más sencilla es especificar manualmente las direcciones en el archivo ***/etc/hosts***.

### Instalación de redis para desarrollo

redis-install.sh:

```bash
# Descarga de tarball
wget https://github.com/antirez/redis/archive/2.8.19.tar.gz
# Extracción
tar xvfz 2.8.19.tar.gz
# Compilación
cd redis-2.8.19
make
```

Uso:

```bash
# Inicia el servidor
src/redis-server
# Inicia el cliente
src/redis-cli
```

### Instalación de PostgreSQL para desarrollo

postgresql-install.sh:

```bash
brew install postgresql
```

Configuración:

```bash
createdb fm_services_dev
# Se sugiere asignar "postgres" como usuario y como contraseña
createuser --interactive -P postgres
```

Uso:

```bash
# Inicia el servidor
postgres -D /usr/local/var/postgres
# Inicia el cliente
psql -h localhost -d fm_services_dev
```

Esquema de la base de datos:

```sql
create table corpus
(
  "ticketId"         integer not null,
  "corpusId"         text not null,
  corpus             text,
  tsv                tsvector,
  unidad             text,
  "noIdentificacion" text,
  "valorUnitario"    float,
  emisor             text not null,
  receptor           text,
  constraint "PK_Constraint_CorpusId" primary key ("corpusId")
)
with (
  OIDS=FALSE
);

alter table corpus owner to postgres;

create trigger tsvectorupdate
before insert or update on corpus for each row execute procedure
tsvector_update_trigger(tsv, 'pg_catalog.spanish', corpus);

create index corpus_tsv_idx on corpus using gin(tsv);

grant insert, select on table corpus to postgres;
```

## Primeros pasos

1. [Escribiendo en redis](#escribiendo-en-redis)
2. [Arrancando XmlIndexer](#arrancando-xmlindexer)
3. Listo 😛👍

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
