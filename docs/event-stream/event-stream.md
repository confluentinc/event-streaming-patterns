---
seo:
  title: Event Stream
  description: 
---
# Event Stream
[Event Processing Applications](../event-processing/event-processing-application.md) need to communicate, and ideally the communication is facilitated with [Events](../event/event.md). The applications need a standard mechanism to use for this communication.

## Problem
How can [Event Processors](../event-processing/event-processor.md) and applications communicate with each other, using event streaming?

## Solution
![event-stream](../img/event-stream.png)

Connect the [Event Processing Applications](../event-processing/event-processing-application.md) with an Event Stream. [Event Sources](../event-source/event-source.md) produce [Events](../event/event.md) to the Event Stream and [Event Processors](../event-processing/event-processor.md) and [Event Sinks](../event-sink/event-sink.md) consume them. Event Streams are named allowing communication over a specific stream of [Events](../event/event.md). Additionally, [Event](../event/event.md) data formats are often validated in order to govern the communication between [Event Processors](../event-processing/event-processor.md).

## Implementation
The streaming database [ksqlDB](https://ksqldb.io/) supports Event Streams using a familiar SQL syntax. The following creates a stream of events representing locations of riders in `JSON` format named `riderLocations`.
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

A persistent query can be ran over the Event Stream using a `SELECT`. As new [Events](../event/events.md) arrive, this query will emit new results matching the `WHERE` conditionals.
```sql
-- Mountain View lat, long: 37.4133, -122.1162
SELECT * FROM riderLocations
  WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5 EMIT CHANGES;
```

## References
* This pattern is derived from [Message Channel](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageChannel.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
