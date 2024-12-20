---
seo:
  title: Event Filter
  description: Event Filter allows Event Processing Applications to operate over a subset of the Events in an Event Stream.
---

# Event Filter
[Event Processing Applications](event-processing-application.md) may need to operate over a subset of [Events](../event/event.md) in an [Event Stream](../event-stream/event-stream.md).

## Problem
How can an application select only the relevant events (or discard uninteresting events) from an Event Stream?

## Solution
![event-filter](../img/event-filter.svg)

## Implementation

As an example, [Apache Flink® SQL](https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/sql/gettingstarted/) lets us create a filtered Event Stream using familiar SQL syntax:

```sql
CREATE TABLE payments_only AS
    SELECT *
      FROM all_transactions
      WHERE type = 'purchase';
```

The [Kafka Streams](https://docs.confluent.io/platform/current/streams/index.html) client library of Apache Kafka® provides a `filter` operator in its DSL. This operator filters out events that do not match a given predicate:

```java
builder
  .stream("transactions-topic")
  .filter((key, transaction) -> transaction.type == "purchase")
  .to("payments-topic");
```

## References
* This pattern is derived from [Message Filter](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Filter.html) in _Enterprise Integration Patterns_, by Gregor Hohpe and Bobby Woolf.
* See the tutorial [How to filter a stream of events with Apache Flink® SQL](https://developer.confluent.io/confluent-tutorials/filtering/flinksql/) for detailed examples of filtering event streams.
