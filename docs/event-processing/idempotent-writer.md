---
seo:
  title: Idempotent Writer
  description: An Idempotent Writer produces an Event to an Event Streaming Platform exactly once.
---

# Idempotent Writer
A writer produces [Events](../event/event.md) that are written into an [Event Stream](../event-stream/event-stream.md), and under stable conditions, each Event is recorded only once.
However, in the case of an operational failure or a brief network outage, an [Event Source](../event-source/event-source.md) may need to retry writes. This may result in multiple copies of the same Event ending up in the Event Stream, as the first write may have actually succeeded even though the producer did not receive the acknowledgement from the [Event Streaming Platform](../event-stream/event-streaming-platform.md). This type of duplication is a common failure scenario in practice and one of the perils of distributed systems.

## Problem
How can an [Event Streaming Platform](../event-stream/event-streaming-platform.md) ensure that an Event Source does not write the same Event more than once?

## Solution
![idempotent-writer](../img/idempotent-writer.svg)

Generally speaking, this can be addressed by native support for idempotent clients.
This means that a writer may try to produce an Event more than once, but the Event Streaming Platform detects and discards duplicate write attempts for the same Event.

## Implementation
To make an Apache Kafka® producer idempotent, configure your producer with the following setting:

```
enable.idempotence=true
```

The Kafka producer tags each batch of Events that it sends to the Kafka cluster with a sequence number. Brokers in the cluster use this sequence number to enforce deduplication of Events sent from this specific producer. Each batch's sequence number is persisted so that even if the [leader broker](https://www.confluent.io/blog/apache-kafka-intro-how-kafka-works/#replication) fails, the new leader broker will also know if a given batch is a duplicate.

To enable exactly-once processing within an Apache Flink® application that uses Kafka sources and sinks, configure the delivery guarantee to be exactly once, either via the [`DeliveryGuarantee.EXACTLY_ONCE`](https://nightlies.apache.org/flink/flink-docs-stable/docs/connectors/datastream/kafka/#fault-tolerance) `KafkaSink` configuration option if the application uses the DataStream Kafka connector, or by setting the [`sink.delivery-guarantee`](https://nightlies.apache.org/flink/flink-docs-stable/docs/connectors/table/kafka/#consistency-guarantees) configuration option to `exactly-once` if it uses one of the Table API connectors. [Confluent Cloud for Apache Flink](https://docs.confluent.io/cloud/current/flink/overview.html) provides built-in exactly-once semantics. Downstream of the Flink application, be sure to configure any Kafka consumer with an [`isolation.level`](https://docs.confluent.io/platform/current/installation/configuration/consumer-configs.html#isolation-level) of `read_committed` since Flink leverages Kafka transactions in the embedded producer to implement exactly-once processing.

To enable [exactly-once processing guarantees](https://docs.confluent.io/platform/current/installation/configuration/streams-configs.html#processing-guarantee) in Kafka Streams or ksqlDB, configure the application with the following setting, which includes enabling idempotence in the embedded producer:

```
processing.guarantee=exactly_once_v2
```

## Considerations
Enabling idempotency for a Kafka producer not only ensures that duplicate Events are fenced out from the topic, it also ensures that they are written in order. This is because the brokers accept a batch of Events only if its sequence number is exactly one greater than that of the last committed batch; otherwise, it results in an out-of-sequence error.

Exactly-once semantics (EOS) allow [Event Streaming Applications](../event-processing/event-processing-application.md) to process data without loss or duplication. This ensures that computed results are always consistent and accurate, even for stateful computations such as joins, [aggregations](../stream-processing/event-aggregator.md), and [windowing](../stream-processing/event-grouper.md). Any solution that requires EOS guarantees must enable EOS at all stages of the pipeline, not just on the writer. An Idempotent Writer is therefore typically combined with an [Idempotent Reader](../event-processing/idempotent-reader.md) and transactional processing.

## References
* [Blog post](https://www.confluent.io/blog/exactly-once-semantics-are-possible-heres-how-apache-kafka-does-it/) about exactly-once semantics in Apache Kafka
* [Blog post](https://flink.apache.org/2018/02/28/an-overview-of-end-to-end-exactly-once-processing-in-apache-flink-with-apache-kafka-too/) about end-to-end exactly-once processing in Apache Flink with Apache Kafka as source and sink
