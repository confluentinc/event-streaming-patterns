---
seo:
  title: Data Contract
  description: The Data Contract pattern allows for an Event Processing Application to send an event to another application, and the receiving application will know how to process it.
---

# Data Contract 

An [Event Processing Application](../event-processing/event-processing-application.md) can send an [Event](../event/event.md) to another Event Processing Application.  It's essential that the communicating applications can understand how to process these shared [Events](../event/event.md).


## Problem
How can an application send an [Event](../event/event.md) such that a receiving application will know how to process it?

## Solution
![data-contract](../img/data-contract.png)

Using a Data Contract or Schema, different [Event Processing Applications](../event-processing/event-processing-application.md) can share [Events](../event/event.md) and understand how to process them without either the sender or receiver to know any details of the other.  The Data Contract pattern allows these different applications to cooperate while remaining loosely coupled, and thus insulated from any internal changes they may implement.  By implementing a data contract or schema, you can provide the same record consistency guarantees as a RDMS which integrate a schema by default.

## Implementation

By using a schema to model event objects, Kafka clients (e.g., a Kafka producer, a Kafka Streams application, the streaming database [ksqlDB](https://ksqldb.io/)) can understand how to handle events from different applications using the same schema.
For example, we can use Avro to describe a schema such as:
```json
{
  "type":"record",
  "namespace": "io.confluent.developer.avro",
  "name":"Purchase",
  "fields": [
    {"name": "item", "type":"string"},
    {"name": "amount", "type": "double"},
    {"name": "customer_id", "type": "string"}
  ]
}
```

Additionally, using a central repository like [Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html) makes it easy for Kafka clients to leverage schemas.

## Considerations

Rather than implementing custom support for a data contract or schemas, you should consider using an industry-accepted framework for schema support, such as the following:

* [Avro](https://avro.apache.org/docs/current/spec.html) 
* [Protobuf](https://developers.google.com/protocol-buffers)
* [JSON schema](https://json-schema.org/).

## References
* [Why use Schema Registry](https://www.confluent.io/blog/schema-registry-kafka-stream-processing-yes-virginia-you-really-need-one/)
