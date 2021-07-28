---
seo:
  title: Idempotent Reader
  description: An idempotent reader can consume the same event once or multiple times, and it will have the same effect.
---

# Idempotent Reader

In ideal circumstances, [Events](../event/event.md) are only written once into an [Event Stream](../event-stream/event-stream.md). Under normal operations, all consumers of the stream will also only read and process each event once. However, depending on the behavior and configuration of the [Event Source](../event-source/event-source.md), failures may occur that create duplicate events. When that happens we need strategies for dealing with them.

There are two causes of duplicate events that an [Idempotent](https://en.wikipedia.org/wiki/Idempotence) Reader must take into consideration:

1. *Operational Failures*: Intermittent network and system failures are unavoidable in distributed systems. In the case of a machine failure or a brief network outage, an [Event Source](../event-source/event-source.md) may produce the same event multiple times due to retries. Similarly, an [Event Sink](../event-sink/event-sink.md) may consume and process same event multiple times due to intermittent offset updating failures. The [Event Streaming Platform](../event-stream/event-streaming-platform.md) should automatically guard against these operational failures by providing strong delivery and processing guarantees, such as those found in Kafka's transactions.

2. *Incorrect Application Logic*: An [Event Source](../event-source/event-source.md) could mistakenly produce the same event multiple times, which become multiple distinct events in an [Event Stream](../event-stream/event-stream.md) from the perspective of the [Event Streaming Platform](../event-stream/event-streaming-platform.md). For example, imagine a bug in the event source that writes a customer payment event twice, instead of just once. The event streaming platform cannot differentiate between the two as it knows nothing of the business logic, and so it considers these as two distinct payment events.

## Problem
How can an application that is reading from an event stream deal with duplicate events?

## Solution
![idempotent-reader](../img/idempotent-reader.svg)

This can be addressed with exactly-once semantics (EOS), including native support for transactions and support for idempotent clients.
EOS allows [Event Streaming Applications](../event-processing/event-processing-application.md) to process data without loss or duplication, which ensures that computed results are always accurate. 

[Idempotent Writing](idempotent-writer.md) by the [Event Source](../event-source/event-source.md) is the first step in solving this problem. This provides strong, exactly-once delivery guarantees of the producer's events, and removes the cause of duplicate events due to operational failures.

On the reading side, [Event Processors](../event-processing/event-processor.md) and [Event Sinks](../event-sink/event-sink.md), an idempotent reader can be configured to read just committed transactions. This prevents events within incomplete transactions from being read, providing the reader isolation from operational writer failures. Keep in mind that idempotency means that the reader's business logic must be able to process the same consumed event multiple times, without generating side-effects or otherwise incorrectly updating its internal state. 

Duplicates caused by incorrect application logic are best resolved by fixing the application's logic. In cases where this is not possible, such as if event generation is triggered by external processes, then the next best option is to tag duplicate events with tracking IDs. The best selection for a tracking ID is a field which is unique to the logical event, such as an event key or request ID. The consumer can then read the tracking ID, cross-reference it against an internal state store of IDs it has already processed, and discard the event if necessary.


## Implementation
To handle operational failures, you can [enable EOS in your streams application](https://www.confluent.io/blog/enabling-exactly-once-kafka-streams/). A Kafka Streams application using EOS will atomically update its consumer offsets, state store changelog topics, reparition topics, and output topics within a single transaction.

In ksqlDB you can enable exactly-once stream processing to execute a read-process-write operation exactly one time. This can be done by setting the processing guarantee with:

```
processing.guarantee="exactly_once"
``` 

To handle incorrect application logic, again, first try to eliminate the source of duplication from the code. If that is not an option, assigning a tracking ID to each event based off of the contents of the event will enable consumers to detect the duplicates for themselves. This will require that each consumer application maintain an internal state store for tracking the events' unique IDs, which will vary in size depending on the event count and the period for which the consumer must guard against duplicates. This option requires both additional disk usage and processing power for inserting and validating events.

For a subset of business cases, it may also be possible to design the consumer processing logic to be idempotent. For example, in a simple ETL where a database is the [Event Sink](../event-sink/event-sink.md), the duplicate events can be deduplicated by the database during an `upsert` on the event ID as primary key. Idempotent business logic also enables your application to read from [Event Streams](../event-stream/event-stream.md) that aren't strictly free of duplicates, or from historic streams that may not have had EOS available at time of creation.

## Considerations
A solution that requires EOS guarantees must enable EOS at all stages of the pipeline, not just on the reader. An Idempotent Reader is therefore typically combined with an [Idempotent Writer](../event-processing/idempotent-writer.md) and transactional processing.

## References
* This pattern is derived from [Idempotent Receiver](https://www.enterpriseintegrationpatterns.com/patterns/messaging/IdempotentReceiver.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* Blog on [Exactly-once semantics in Apache Kafka](https://www.confluent.io/blog/simplified-robust-exactly-one-semantics-in-kafka-2-5/)
* [Idempotent Producer Kafka Tutorial](https://kafka-tutorials.confluent.io/message-ordering/kafka.html)
