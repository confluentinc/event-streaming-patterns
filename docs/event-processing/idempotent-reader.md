---
seo:
  title: Idempotent Reader
  description: An idempotent reader can consume the same event once or multiple times, and it will have the same effect.
---

# Idempotent Reader
Generally speaking, we want to believe that [Events](../event/event.md) get written into an [Event Stream](../event-stream/event-stream.md) once and read from it once, and that we don't need to handle multiple occurrences of published events.
However, depending on the behavior and configuration of the [Event Source](../event-source/event-source.md), failures may occur that create duplicate events. When that happens we need strategies for dealing with them.

There are two causes of duplicate events that the Idempotent Reader should take into consideration:

1. Operational failure: in the case of a machine failure or a brief network outage, an [Event Source](../event-source/event-source.md) could produce the same event multiple times, or an [Event Sink](../event-sink/event-sink.md) could consume and process same event multiple times. This type of duplication is inherent to distributed systems. The [Event Streaming Platform](../event-stream/event-streaming-platform.md) should automatically guard against this by providing strong delivery and processing guarantees, such as those found in Kafka transactions.

2. Incorrect application logic: an [Event Source](../event-source/event-source.md) could mistakenly produce the same event multiple times, which become multiple distinct events in an [Event Stream](../event-stream/event-stream.md) from the perspective of the [Event Streaming Platform](../event-stream/event-streaming-platform.md). For example, imagine a bug in the event source that results in always writing a customer payment three times instead of once into an event stream. The event streaming platform rightly considers these as three distinct payments, and it cannot guard against these types of duplicates automatically.

## Problem
How can an application that is reading from an event stream deal with duplicate events?

## Solution
![idempotent-reader](../img/idempotent-reader.svg)

This can be addressed with exactly-once semantics (EOS), including native support for transactions and idempotent clients.
EOS allows [Event Streaming Applications](../event-processing/event-processing-application.md) to process data without loss or duplication, which ensures that computed results are always accurate. 

To prevent duplicates caused by operational failures when writing events into the [Event Streaming Platform](../event-stream/event-streaming-platform.md), the platform should support strong delivery guarantees and, in particular, EOS.  For [Event Sources](../event-source/event-source.md), i.e., on the writing side, a common choice to achieve EOS is the use of an Idempotent Writer. For [Event Processors](../event-processing/event-processor.md) and [Event Sinks](../event-sink/event-sink.md), i.e., the reading side, an idempotent reader can be configured to read just committed transactions.

Meanwhile, if the Event Source is still capable of duplicating the same logical event, then the consumer application logic will need to handle those duplicates.
This can be done by tracking unique IDs within each event, whereby the ID could be the event key or a field embedded in the event message.
As a consumer application reads events, it tracks in a local store which IDs have been processed, and if it comes across another event with an existing ID in the database, it discards the event.

## Implementation
To handle an operational failure, you can [enable EOS in your streams application](https://www.confluent.io/blog/enabling-exactly-once-kafka-streams/) so that the application atomically updates its own local consumer offsets (which track how far the consumer application has read from the commit log) along with its local state stores and related topics.
For Kafka consumers, automatic commits of consumer offsets are convenient for developers, but they don’t give enough control to avoid duplicate messages.
So disable auto commit to maintain full control over when the application commits offsets to minimize duplicates.

With ksqlDB where you can have exactly-once stream processing to execute a read-process-write operation exactly one time, you can enable exactly-once semantics with:

```
processing.guarantee="exactly_once"
``` 

To handle incorrect application logic, which could result in the same event being written multiple times to the Kafka commit log (they actually are distinct events according to the [Event Store](../event-store/event-store.md)), the consumer application needs to maintain a local store for tracking the events' unique IDs.
Then all event reading will entail checking the ID against the already-processed IDs before proceeding.

For a subset of use cases, it may also be possible to design the consumer processing logic to be [idempotent](https://en.wikipedia.org/wiki/Idempotence).
For example, in a simple ETL where a database is the [Event Sink](../event-sink/event-sink.md), the duplicate events can be deduped to the database with an `upsert`, where typically the event ID is the primary key in the database.
More generally, instead of avoiding duplicate events or using transactions, you could design the application such that the same event could actually be processed more than once and still have the same net effect as if it had been processed just once.

## Considerations
A solution that necessitates strong EOS guarantees should enable EOS at all stages of the pipeline, not just on the reader.
An Idempotent Reader is therefore typically combined with an [Idempotent Writer](../event-processing/idempotent-writer.md) and transactional processing.

## References
* This pattern is derived from [Idempotent Receiver](https://www.enterpriseintegrationpatterns.com/patterns/messaging/IdempotentReceiver.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* Blog on [Exactly-once semantics in Apache Kafka](https://www.confluent.io/blog/simplified-robust-exactly-one-semantics-in-kafka-2-5/)
* [Idempotent Producer Kafka Tutorial](https://kafka-tutorials.confluent.io/message-ordering/kafka.html)
