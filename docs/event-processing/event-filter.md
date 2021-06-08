---
seo:
  title: Event Filter
  description: Event Filter allows event processing applications to operate over a subset of Events in an Event Stream
---

# Event Filter
[Event Processing Applications](event-processing-application.md) may need to operate over a subset of [Events](../event/event.md) in an [Event Stream](../event-stream/event-stream.md).

## Problem
How can an application select only the relevant events (or discard uninteresting events) from an Event Stream?

## Solution
![event-filter](../img/event-filter.png)


## Implementation

[ksqlDB](https://ksqldb.io) provides the ability to create a filtered Event Stream using familiar SQL syntax:
```sql
CREATE STREAM allisons_races WITH (kafka_topic = 'allisons-races-topic') AS
    SELECT *
      FROM all_races
      WHERE racer = 'Allison';
```

The Kafka Streams DSL provides a `filter` operator which filters out events that do not match a given predicate.

```java
builder
  .stream("all-races-topic")
  .filter((key, race) -> race.racer == "Allison")
  .to("allisons-races-topic");
```

## References
* This pattern is derived from [Message Filter](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Filter.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* See this [Kafka Tutorial](https://kafka-tutorials.confluent.io/filter-a-stream-of-events/ksql.html) for a full example of filtering event streams.


