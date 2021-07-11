---
seo:
  title: Event Serializer
  description: An Event Serializer encodes events so that they can be written to disk, transferred across the network, and generally preserved for future readers.
---

# Event Serializer

Data has a long lifecycle, often outliving the programs that
originally gathered and stored it. And data has a broad
audience: the more accessible our data is, the more departments in
our organization can find a use for it. 

In a successful system, data gathered by the sales department one
year may prove invaluable to the marketing department a few years
later, _provided that they can actually access it_.

For maximum utility and longevity, data should be written in a way
that doesn't obscure it from future readers and writers. The data is
more important than today's technology choices.

How does this affect an event-based system? Are there any special
concerns for this kind of architecture, or will a programming
language's serialization tools suffice?

## Problem

How can I convert an event into a format understood by the event
streaming platform and its client applications?

## Solution

![event serializer](../img/event-serializer.svg)

Use a language-agnostic serialization format. The ideal format would
be self-documenting, space-efficient, and designed to support a
degree of backwards compatibility and forwards compatibility. We recommend
[Apache Avro][avro] (see "Considerations").

An optional (but recommended) step is to register the serialization details
with a schema registry. A registry provides a reliable,
machine-readable reference point for [Event
Deserializers](./event-deserializer.md) and [Schema
Validators](../event-source/schema-validator.md), making event
consumption vastly simpler.

## Implementation

As an example, we can use Avro to define a structure for Foreign Exchange
trade deals:

```json
{"namespace": "io.confluent.developer",
 "type": "record",
 "name": "FxTrade",
 "fields": [
     {"name": "trade_id", "type": "long"},
     {"name": "from_currency", "type": "string"},
     {"name": "to_currency", "type": "string"},
     {"name": "price", "type": "bytes", "logicalType": "decimal", "precision": 10, "scale": 5}
 ]
}
```

Then we can use our language's Avro libraries to take care of serialization for us:

```java
  FxTrade fxTrade = new FxTrade( ... );

  ProducerRecord<long, FxTrade> producerRecord =
    new ProducerRecord<>("fx_trade", fxTrade.getTradeId(), fxTrade);

  producer.send(producerRecord);
```

Alternatively, using the streaming database
[ksqlDB](https://ksqldb.io/), we can define an [Event
Stream](../event-stream/event-stream.md) in a way that enforces the
format and records the Avro definition using the Confluent [Schema
Registry](https://docs.confluent.io/platform/current/schema-registry/index.html):

```sql
CREATE OR REPLACE STREAM fx_trade (
  trade_id BIGINT KEY,
  from_currency VARCHAR(3),
  to_currency VARCHAR(3),
  price DECIMAL(10,5)
) WITH (
  KAFKA_TOPIC = 'fx_trade',
  KEY_FORMAT = 'avro',
  VALUE_FORMAT = 'avro',
  PARTITIONS = 3
);
```

With this setup, ksqlDB performs both serialization and deserialization of data automatically, behind the scenes.

## Considerations

[Event Streaming
Platforms](../event-stream/event-streaming-platform.md) typically
are serialization-agnostic and accept any serialized data, from
human-readable text to raw bytes. However, by constraining ourselves
to more widely-accepted structured data formats, we can open the door
to easier collaboration with other projects and programming languages.

Finding a "universal" serialization format isn't a new problem, or
one unique to event streaming. As such, we have a number of
technology-agnostic solutions readily available. These include:

* [JSON](https://www.json.org/). Arguably the most successful
  serialization format in the history of computing. JSON is a
  text-based format that's easy to read, write, and
  [discover](https://en.wikipedia.org/wiki/Discoverability)<sup>1</sup>,
  as evidenced by the number of languages and projects that produce
  and consume JSON data across the world with minimal collaboration.
* [Protocol
  Buffers](https://developers.google.com/protocol-buffers) (Protobuf). Backed by
  Google and supported by a wide variety of languages, Protobuf is a
  binary format that sacrifices the discoverability of JSON for a much
  more compact representation that uses less disk space and network
  bandwidth. Protobuf is also a strongly-typed format, allowing
  enforcement of a particular data schema from writers, and describing
  the structure of the data to readers.
* [Avro][avro]. A binary format similar to
  Protocol Buffers, Avro's design focuses on supporting the
  evolution of schemas, allowing the data format to change over time
  while minimizing the impact to future readers and writers.

While the choice of serialization format is important, it doesn't have
to be set in stone. ksqlDB makes it straightforward to [translate between
supported formats](https://kafka-tutorials.confluent.io/changing-serialization-format/ksql.html). For
more complex scenarios, there are several strategies for managing schema
migration:

* [Schema
  Compatibility](../event-stream/schema-evolution/)
  discusses the kinds of "safe" schema changes that Avro is designed
  to handle transparently.
* [Event Translators](../event-processing/event-translator.md) can
  convert between different encodings to aid consumption from different
  systems.
* [Schema
  Evolution](../event-stream/schema-evolution/)
  discusses splitting and joining streams to make it easier to serve
  consumers that can only handle certain versions of the event's
  schema.
* An [Event Standardizer](./event-standardizer.md) can reformat
  disparate data encodings into a single unified format.
* And as a fallback, we can push the problem to the consumer's code
  with a [Schema-on-Read](./schema-on-read.md) strategy.

## References

* The counterpart of an event serializer (used for writing) is an [Event Deserializer](./event-deserializer.md) (used for reading).
* Serializers and deserializers are closely related to [Data
  Contracts](./data-contract.md), where we want to adhere to a
  specific serialization format _and_ constrain individual events
  to a certain schema within that format.
* See also the [Event Mapper](../event-processing/event-mapper.md) pattern.

## Footnotes

_<sup>1</sup> Older programmers will tell tales of the
less-discoverable serialization formats used by banks in the '80s, in
which deciphering the meaning of a message meant wading through a
thick, ring-bound printout of the data specification, which explained the
meaning of "Field 78" by cross-referencing "Encoding Subformat 22"._

[Avro]: https://avro.apache.org/docs/current/
