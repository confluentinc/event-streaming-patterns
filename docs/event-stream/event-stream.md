---
seo:
  title: Event Stream
  description: Event Streams are the communication mechanism of Event Processing Applications. You can connect Event Processing Applications together using an Event Stream. Event Streams are often named and contain Events of a well-known format.
---
# Event Stream
[Event Processing Applications](../event-processing/event-processing-application.md) need to communicate, and ideally the communication is based on [Events](../event/event.md). The applications need a standard mechanism to use for this communication.

## Problem
How can [Event Processors](../event-processing/event-processor.md) and applications communicate with each other using event streaming?

## Solution
![event-stream](../img/event-stream.svg)

Connect the Event Processing Applications with an Event Stream. [Event Sources](../event-source/event-source.md) produce events to the Event Stream, and Event Processors and [Event Sinks](../event-sink/event-sink.md) consume them. Event Streams are named, allowing communication over a specific stream of events. Notice how Event Streams decouple the source and sink applications, which communicate indirectly and asynchronously with each other through events. Additionally, event data formats are often validated, in order to govern the communication between applications.

Generally speaking, an Event Stream records the history of what has happened in the world as a sequence of events (think: a sequence of facts). Examples of streams would be a sales ledger or the sequence of moves in a chess match. This history is an ordered sequence or chain of events, so we know which event happened before another event and can infer causality (for example, “White moved the e2 pawn to e4; then Black moved the e7 pawn to e5”). A stream thus represents both the past and the present: as we go from today to tomorrow -- or from one millisecond to the next -- new events are constantly being appended to the history.

Conceptually, a stream provides _immutable_ data. It supports only inserting (appending) new events, and existing events cannot be changed. Streams are persistent, durable, and fault-tolerant. Unlike traditional message queues, events stored in streams can be read as often as needed by Event Sinks and Event Processing Applications, and they are not deleted after consumption. Instead, retention policies control how events are retained. Events in a stream can be _keyed_, and we can have many events for one key. For a stream of payments of all customers, the customer ID might be the key (cf. related patterns such as [Partitioned Parallelism](../event-stream/partitioned-parallelism.md)).

## Implementation
In [Apache Kafka®](/learn-kafka/apache-kafka/events/), Event Streams are called _topics_. Kafka allows you to define policies which dictate how events are retained, using [time or size limitations](../event-storage/limited-retention-event-stream.md) or [retaining events forever](../event-storage/infinite-retention-event-stream.md). Kafka consumers (Event Sinks and Event Processing Applications) are able to decide where in an event stream to begin reading. They can choose to begin reading from the oldest or newest event, or seek to a specific location in the topic, using the event's timestamp or position (called the _offset_).

Streaming technologies support Kafka-based Event Streams as a core abstraction. For example:

* The [Kafka Streams DSL API](https://kafka.apache.org/30/documentation/streams/developer-guide/dsl-api.html) provides abstractions for Event Streams, notably the [`KStream`](https://docs.confluent.io/platform/current/streams/javadocs/javadoc/org/apache/kafka/streams/kstream/KStream.html) interface for unbounded data streams and the [`KTable`](https://docs.confluent.io/platform/current/streams/javadocs/javadoc/org/apache/kafka/streams/kstream/KTable.html) interface for changelog data on keyed records (e.g., a `KTable` of product updates keyed on product ID).
* The Apache Flink® [`Table`](https://nightlies.apache.org/flink/flink-docs-stable/api/java/org/apache/flink/table/api/Table.html) interface is the Flink (Java) Table API's core abstraction for Event Streams. PyFlink's Table API is also built around a [`Table`](https://pyflink.readthedocs.io/en/main/getting_started/quickstart/table_api.html#Table-Creation) object.
* [Flink SQL](https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/sql/gettingstarted/) supports Event Streams using a familiar standard SQL syntax.

## References
* This pattern is derived from [Message Channel](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageChannel.html) in _Enterprise Integration Patterns_, by Gregor Hohpe and Bobby Woolf.
* Tutorials demonstrating how to build basic stream processing applications that manipulate Event Streams: with [Kafka Streams](https://developer.confluent.io/confluent-tutorials/creating-first-apache-kafka-streams-application/kstreams/), with [Flink SQL](https://developer.confluent.io/confluent-tutorials/filtering/flinksql/), with the [Flink Table API](https://developer.confluent.io/courses/flink-table-api-java/exercise-connecting-to-confluent-cloud/).
