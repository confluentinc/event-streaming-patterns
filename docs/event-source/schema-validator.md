# Schema Validator
In an [Event Streaming Platform](TODO: pattern link), [Event Sources](TODO: pattern link), which create and write [Events](../event/event.md), are decoupled from [Event Sinks](TODO: pattern link) and [Event Processing Applications](../event-processing/event-processing-application.md), which read and process these events. Ensuring interoperability between the producers and the consumers of events requires that they agree on the data schemas for the events, which is an important aspect of putting [Data Contracts](TODO: pattern link) in place for data governance purposes.

## Problem
How do I enforce that Events sent to an Event Stream conform to a defined schema for that stream?

## Solution
![schema-validator](../img/schema-validator.png)
A Schema Validator enforces the data format for Events prior to them being written to an Event Stream allowing Event Processing Applications to read Events based on a known schema.

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
Schema Validator is a data governence implementation of "Schema on Write", enforcing data conformance prior to Event publication. An alternative strategy is [Schema On Read](../event/schema-on-read.md) where data formats are not enforced on write and consuming Event Processing Applications are required to validate data formats as they read each event. 

## References
* See the [Schema Compatibility](../event-stream/schema-compatibility.md) for information on how schemas can be verified
* The [Schema Validation with Confluent Platform](https://www.confluent.io/blog/data-governance-with-schema-validation/) blog describes data governance on the Confluent Platform
* [Subject Name Strategy](https://docs.confluent.io/platform/current/schema-registry/serdes-develop/index.html#subject-name-strategy) documentation describes the method used by [Confluent's Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html) to map event streams to schemas.
