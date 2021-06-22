---
seo:
  title: Event Stream
  description: Event Streams are the mechanism for Event Processing Applications to communicate. Connect Event Processing Applications together using an Event Stream. Event streams are often named and contain Events of a well known format.
---
# Event Stream
[Event Processing Applications](../event-processing/event-processing-application.md) need to communicate, and ideally the communication is facilitated with [Events](../event/event.md). The applications need a standard mechanism to use for this communication.

## Problem
How can [Event Processors](../event-processing/event-processor.md) and applications communicate with each other, using event streaming?

## Solution
![event-stream](../img/event-stream.png)

Connect the [Event Processing Applications](../event-processing/event-processing-application.md) with an Event Stream. [Event Sources](../event-source/event-source.md) produce [Events](../event/event.md) to the Event Stream, and [Event Processors](../event-processing/event-processor.md) and [Event Sinks](../event-sink/event-sink.md) consume them. Event Streams are named, allowing communication over a specific stream of [Events](../event/event.md). Note how Event Streams decouple the source and sink applications, which communicate indirectly and asynchronously with each other through events. Additionally, Event data formats are often validated in order to govern the communication between applications.

Generally speaking, an Event Stream records the history of what has happened in the world as a sequence of events (think: a sequence of facts). An example stream is a sales ledger or the sequence of moves in a chess match. This history is an ordered sequence or chain of events, so we know which event happened before another event to infer causality (e.g., “White moved the e2 pawn to e4, then Black moved the e7 pawn to e5”). A stream thus represents both the past and the present: as we go from today to tomorrow—or from one millisecond to the next—new events are constantly being appended to the history.

Technically, a stream provides immutable data. It supports only inserting (appending) new events, whereas existing events cannot be changed. Streams are persistent, durable, and fault tolerant. Events in a stream can be keyed, and we can have many events for one key, such as the customer ID as the key for a stream of payments of all customers.

## Implementation
The streaming database [ksqlDB](https://ksqldb.io/) supports Event Streams using a familiar SQL syntax. The following example creates a stream of events named `riderLocations`, representing locations of riders in a car-sharing service. The data format is `JSON`.
```sql
CREATE STREAM riderLocations (profileId VARCHAR, latitude DOUBLE, longitude DOUBLE)
  WITH (kafka_topic='locations', value_format='json');
```

New [Events](../event/event.md) can be written to the `riderLocations` stream using the `INSERT` syntax:
```sql
INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('c2309eec', 37.7877, -122.4205);
INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('18f4ea86', 37.3903, -122.0643);
INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('4ab5cbad', 37.3952, -122.0813);
INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('8b6eae59', 37.3944, -122.0813);
INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('4a7c7b41', 37.4049, -122.0822);
INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('4ddad000', 37.7857, -122.4011);
```

A [push query](https://docs.ksqldb.io/en/latest/concepts/queries/#push) a.k.a. a streaming query can be ran continuously over the stream using a `SELECT`, using the `EMIT CHANGES` clause. As new events arrive, this query will emit new results matching the `WHERE` conditionals. The following query looks for riders in close proximity to Mountain View, California, in the United States.
```sql
-- Mountain View lat, long: 37.4133, -122.1162
SELECT * FROM riderLocations
  WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5
  EMIT CHANGES;
```

## References
* This pattern is derived from [Message Channel](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageChannel.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
[comment]: <> (TODO: reference Kafka Storage & Processing Fundamentals page instead of the following blog series directly)
* The blog post series, [Streams and Tables in Apache Kafka: A Primer](https://www.confluent.io/blog/kafka-streams-tables-part-1-event-streaming/) goes into detail on streams, tables and other Kafka fundamentals.
