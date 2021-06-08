---
seo:
  title: Lifecycle Event
  description: The general use case for Lifecycle Event is when the sequencing matters between events of different types.  
---

# Lifecycle Event
The general use case for Lifecycle Event is when the sequencing matters between messages of different types.
For example, consider a finserv use case where first a customer opens an account, then gets approval, then makes a deposit, etc; the sequencing really matters.
Put these heterogeneous [Event](../events/event.md) types into the same stream, allowing the [Event Streaming Platform](../event-stream/event-streaming-platform.md) maintain ordering and the consumer application deserialize the events.

## Problem
How do I read events from a stream that may have multiple schemas, with different code paths in the [Event Processor](../event-processing/event-processor.md) to handle each one?

## Solution
![lifecycle-event](../img/lifecycle-event.png)

## Implementation
Confluent Schema Registry checks that schema changes are compatible with previous versions.
In order to have different event types in the same Kafka topic, set the "subject naming strategy" to register schemas against the record type, instead of the Kafka topic.
Then the consumer application can cast each event to the appropriate type at processing time and follow the appropriate code path:

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
* [Blog Should You Put Several Event Types in the Same Kafka Topic?"](https://www.confluent.io/blog/put-several-event-types-kafka-topic/)
* [Confluent Schema Registry](https://docs.confluent.io/cloud/current/cp-component/schema-reg-cloud-config.html)
