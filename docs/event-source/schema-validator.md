# Schema Validator
In an [Event Streaming Platform](TODO: pattern link), [Event Sources](TODO: pattern link), which create and write [Events](../event/event.md), are decoupled from [Event Sinks](TODO: pattern link) and [Event Processing Applications](../event-processing/event-processing-application.md), which read and process these events. Ensuring interoperability between the producers and the consumers of events requires that they agree on the data schemas for the events, which is an important aspect of putting [Data Contracts](TODO: pattern link) in place for data governance purposes.

## Problem
How do I enforce that Events sent to an Event Stream conform to a defined schema for that stream?

## Solution
![schema-validator](../img/schema-validator.png)
Validate whether an event conforms to the defined schema(s) of an [Event Stream](TODO: pattern link) prior to writing the event to the stream.  Such schema validation can be done:

1. On the server side by the Event Streaming Platform that receives the event. Events that fail schema validation and thus violate the [Data Contract](TODO: pattern link) are rejected.
2. On the client side by the [Event Source](TODO: pattern link) that creates the event. For example, an [Event Source Connector](TODO: pattern link) can validate events prior to ingestion into the Event Streaming Platform. Or, an [Event Processing Application](TODO: pattern link) can use the schema validation functionality provided by a serialization library that supports schemas (e.g., Confluent's serializer/deserializers for Kafka).

## Implementation
With Confluent, Schema Validation is enabled on the brokers by pairing them with a [Schema Registry]((https://docs.confluent.io/platform/current/schema-registry/index.html)): 
```
confluent.schema.registry.url=http://schema-registry:8081 
```

Once the Schema Registry is enabled, topics can be configured to enforce schemas with a basic configuration:
```
kafka-topics --create --bootstrap-server localhost:9092 --replication-factor 1 \
--partitions 1 --topic movies \
--config confluent.value.schema.validation=true
```

## Considerations
Schema Validator is a data governance implementation of "Schema on Write", which enforces data conformance prior to event publication. An alternative strategy is [Schema On Read](../event/schema-on-read.md), where data formats are not enforced on write. Instead, consuming [Event Processing Applications](TODO: pattern link) are required to validate data formats as they read each event. 
* Server-side schema validation is preferable when you want to enforce this pattern centrally inside an organization.  In contrast, client-side validation assumes the cooperation of client applications and their developers, which may or may not be acceptable (e.g., in regulated industries).
* Schema validation results in a load increase because it impacts the write path of every event.  Client-side validation impacts primarily the load of the client applications.  Server-side schema validation increases the load on the event streaming platform, whereas client applications are less affected (here, the main impact is dealing with rejected events; see [Dead Letter Stream](TODO: pattern link)).
## References
* See the [Schema Compatibility](../event-stream/schema-compatibility.md) pattern for information on how schemas can evolve over time and be verified.
* Learn more how to [Manage and Validate Schemas with Confluent and Kafka](https://docs.confluent.io/cloud/current/client-apps/schemas-manage.html).
