---
seo:
  title: Event Aggregator
  description: An Event Aggregator performs an aggregation across multiple related Events to produce a new Event.
---
# Event Aggregator

Combing multiple [Events](../event/event.md) into a single encompassing Event--for example, to compute totals or averages--is a common task in event streaming and streaming analytics.

## Problem

How can multiple related Events be aggregated to produce a new Event?

## Solution

If we need to produce a single Event containing an aggregation of values from Events within a window of time (for example, to compute five-minute averages), we can use a windowed Event Aggregator to collect and process the values from those events, and then emit a single Event at the close of the window.

## Implementation

![event-aggregator](../img/event-aggregator_a.png)

As an example, we can use the streaming database [ksqlDB](https://ksqldb.io/) and Apache Kafka® to perform this aggregation.

We'll start by using ksqlDB to create a stream called `orders`, based on an existing Kafka topic of the same name:
```sql
  CREATE STREAM orders (order_id INT, item_id INT, total_units DOUBLE)
    WITH (KAFKA_TOPIC='orders', VALUE_FORMAT='AVRO');
```

Then we'll create a table containing the aggregated Events from the `orders` stream:
```sql
  CREATE TABLE item_stats AS 
    SELECT item_id, COUNT(*) AS total_orders, AVG(total_units) AS avg_units
    FROM orders
    WINDOW TUMBLING (SIZE 1 HOUR)
    GROUP BY item_id 
    EMIT CHANGES;  
```

This table will be continuously updated whenever new Events arrive in the `orders` stream.

## Considerations
* In event streaming, a key technical challenge is that—with few exceptions—it is not possible to tell whether the input data is "complete" at a given point in time. For this reason, stream processing technologies, such as [ksqlDB](https://ksqldb.io/) and the Kafka client library Kafka Streams, employ techniques such as _slack time_<sup>1</sup> and _grace periods_ (see the [`GRACE PERIOD`](https://docs.ksqldb.io/en/latest/concepts/time-and-windows-in-ksqldb-queries/) clause in ksqlDB) or watermarks to define cutoff points after which an [Event Processor](../event-processing/event-processor.md) will discard any late-arriving input Events from its processing. (For additional information, see the [Suppressed Event Aggregator](../stream-processing/suppressed-event-aggregator.md) pattern.)

## References
* For more detailed examples of event aggregation, see the following tutorials: [How to sum a stream of events](https://kafka-tutorials.confluent.io/create-stateful-aggregation-sum/ksql.html) and [How to count a stream of events](https://kafka-tutorials.confluent.io/create-stateful-aggregation-count/ksql.html).
* See also the [Suppressed Event Aggregator](../stream-processing/suppressed-event-aggregator.md) pattern.

## Footnotes

1. Slack time: [Beyond Analytics: The Evolution of Stream Processing Systems (SIGMOD 2020)](https://dl.acm.org/doi/abs/10.1145/3318464.3383131), [Aurora: a new model and architecture for data stream management (VLDB Journal 2003)](https://dl.acm.org/doi/10.1007/s00778-003-0095-z)
