---
seo:
  title: Idempotent Reader
  description: An idempotent reader can consume the same event once or multiple times, and it will have the same effect.
---

# Idempotent Reader
Generally speaking, we want to believe that [Events](../event/event.md) get written into an [Event Stream](../event-stream/event-stream.md) once and read from it once, and that we don't need to handle multiple occurrences of published events.
However, depending on the behavior and technical limits of the [Event Source](../event-source/event-source.md), how it is configured, and what failures may happen, we do need to think about whether there is the risk of duplicate events and, if there are, how we can deal with them.

There are two causes of duplicate events that the Idempotent Reader should take into consideration:

1. Operational failure: in the case of a machine failure or a brief network outage, an [Event Source](../event-source/event-source.md) could produce the same event twice, or an [Event Sink](../event-sink/event-sink.md) could consume the same event twice. This type of duplicate is one of the perils of distributed systems. The [Event Streaming Platform](../event-stream/event-streaming-platform.md) should automatically guard against this type of duplicates by providing strong delivery and processing guarantees, such as transactions.

2. Incorrect application logic: an [Event Source](../event-source/event-source.md) could mistakenly produce the same event multiple times, which become multiple distinct events in an [Event Stream](../event-stream/event-stream.md) from the perspective of the [Event Streaming Platform](../event-stream/event-streaming-platform.md). For example, imagine a bug in the event source that results in always writing a customer payment three times instead of once into an event stream. The event streaming platform rightly considers these as three distinct payments, and it cannot guard against these types of duplicates automatically.

## Problem
How can an application that is reading from a distributed event streaming platform deal with duplicate events?

## Solution
![idempotent-reader](../img/idempotent-reader.png)

Generally speaking, this can be addressed with exactly-once semantics (EOS), including native support for transactions and idempotent clients.
EOS allows [Event Streaming Applications](../event-processing/event-processing-application.md) to process data without loss or duplication, which ensures that computed results are always accurate. 

To prevent duplicates caused by operational failures when writing events into the [Event Streaming Platform](../event-stream/event-streaming-platform.md), the platform should support strong delivery guarantees and, in particular, EOS.  For [Event Sources](../event-source/event-source.md), i.e., on the writing side, a common choice to achieve EOS is the use of an Idempotent Writer. For [Event Processors](../event-processing/event-processor.md) and [Event Sinks](../event-sink/event-sink.md), i.e., the reading side, an idempotent reader can be configured to read just committed transactions.

However, if the Event Source is still capable of duplicating the same logical event, then the consumer application logic will need to handle duplicates.
It can do this by tracking unique IDs within each event.
The ID could be the event key or a field embedded in the event message, and it is up to the consumer application to track when IDs have been processed.
If it comes across another event with the same ID, it discards it.

## Implementation
To handle an operational failure, you can enable EOS in your Kafka Streams application so that the application atomically updates its own local consumer offsets (which track how far the consumer application has read from the commit log) along with its local state stores and related topics.
For Kafka consumers, automatic commits of consumer offsets are convenient for developers, but they don’t give enough control to avoid duplicate messages.
So disable auto commit to maintain full control over when the application commits offsets to minimize duplicates.

To handle incorrect application logic, which could result in the same event being written multiple times to the Kafka commit log (they actually are distinct events according to the [Event Store](../event-store/event-store.md)), the consumer application needs to maintain a local store for tracking these IDs.
Then all event reading will entail checking the ID against the already-processed IDs before proceeding.

Although it may apply to a subset of use cases, it may also be possible to design the consumer processing logic to be idempotent.
Thus, instead of the strategy of avoiding duplicate events or discarding duplicate events, you could design the application such that the same event could be processed more than once and have the same net effect as if it had been processed just once.

## Considerations
A solution that necessitates strong EOS guarantees should enable EOS at all stages of the pipeline, not just on the reader.
An Idempotent Reader is therefore typically combined with an Idempotent Writer, as well as transactions.

## References
* This pattern is derived from [Idempotent Receiver](https://www.enterpriseintegrationpatterns.com/patterns/messaging/IdempotentReceiver.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* Blog on [Exactly-once semantics in Apache Kafka](https://www.confluent.io/blog/simplified-robust-exactly-one-semantics-in-kafka-2-5/)
* [Idempotent Producer Kafka Tutorial](https://kafka-tutorials.confluent.io/message-ordering/kafka.html)
