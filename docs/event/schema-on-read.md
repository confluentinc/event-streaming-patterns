---
seo:
  title: Schema-on-Read
  description: Schema on Read enables the reader of data to determine which schema to apply to the data that is processed.
---

# Schema-on-Read
Schema-on-Read leaves the validation of a schema for an [Event](../event/event.md) to the reader.
There are several use cases for this pattern, all of which provide a lot of flexibility to [Event Processors](../event-processing/event-processor.md):

1. When there are different versions of the same schema type, and the reader wants to choose which version to apply to a given event.

2. When the sequencing matters between events of different types and all those different event types are put into a single stream.  For example, consider a banking use case where first a customer opens an account, then gets approval, then makes a deposit, etc. Put these heterogeneous [Event](../events/event.md) types into the same stream, allowing the [Event Streaming Platform](../event-stream/event-streaming-platform.md) maintain event ordering and allowing any consuming [Event Processor](../event-processing/event-processor.md) and [Event Sinks](../event-sink/event-sink.md) [deserialize the events](../event/event-deserializer.md) as needed.

3. When unstructured data is written into an [Event Stream](../event-stream/event-stream.md), and the reader then applies whichever schema it wants.

## Problem
How can an [Event Processor](../event-processing/event-processor.md) apply a schema on the data it is reading from an [Event Streaming Platform](../event-stream/event-streaming-platform.md)?

## Solution
![schema-on-read](../img/schema-on-read.png)

The Schema-on-Read approach approach enables each reader to decide on how to read data, and which version of which schema to apply to every [Event](../events/event.md) that it reads.
To make schema management easier, the design can use a centralized repository that can store multiple versions of different schemas, and then the client applications then choose which schema to apply to events at runtime.

## Implementation
With Confluent Schema Registry, all the schemas are managed in a centralized repository.
In addition to just storing the schema information, Schema Registry can also be configured to check and/or enforce that schema changes are compatible with previous versions.

For example, if a business started with a schema definition for an event that has 2 fields, but then the business needs evolved to now warrant an optional 3rd field, then that schema evolves with it.
Schema Registry will ensure that the new schema is compatible with the old schema.
In this particular case, for backward compatibility, the 3rd field `status` can be defined with a default value which will be used for the missing field when deserializing the data encoded with the old schema 

```
{
 "namespace": "example.avro",
 "type": "record",
 "name": "user",
 "fields": [
     {"name": "name", "type": "string"},
     {"name": "address",  "type": "string"},
     {"name": "status", "type": "string", "default": "waiting"}
 ]
}
```

In another example, if the use case warrants writing different event types into a single stream, with Apache Kafka you could set the "subject naming strategy" to register schemas against the record type, instead of the Kafka topic.
Schema Registry will then let schema evolution and compatibility checking to happen within the scope of each event type instead of the topic.

The consumer application can read schema versions assigned to the data type, and in the case where there are different data types in any given stream, the application can cast each event to the appropriate type at processing time and follow the appropriate code path:

```java
if (Account.equals(record.getClass()) {
  ...
} else if (Approval.equals(record.getClass())) {
  ...
} else if (Transaction.equals(record.getClass())) {
  ...
} else {
  ...
}
```

## Considerations
The schema's subject naming strategy can be set to record type (instead of Kafka topic) in one of two ways.
The less restrictive is `RecordNameStrategy`, which sets the namespace to the record, regardless of which topic the event is written to.
The more restrictive is `TopicRecordNameStrategy`, which sets the namespace to both, the record and the topic the event is  written to.

## References
* Confluent blog [Should You Put Several Event Types in the Same Kafka Topic?](https://www.confluent.io/blog/put-several-event-types-kafka-topic/)
* [Confluent Schema Registry](https://docs.confluent.io/cloud/current/cp-component/schema-reg-cloud-config.html)
