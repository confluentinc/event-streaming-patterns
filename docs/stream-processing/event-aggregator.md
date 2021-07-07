---
seo:
  title: Event Aggregator
  description: Perform an aggregation across multiple related events to produce a new event.
---
# Event Aggregator

Combing multiple events into a single encompassing event—e.g., to compute totals, averages, etc. is a common task in event streaming and streaming analytics.

## Problem

How can multiple related events be aggregated to produce a new event?

## Solution

If we need to produce a single event containing an aggregation of values from events within a window of time (e.g., to compute 5-minute averages), we can use a windowed aggregator to collect and process the values from those events, and then emit a single event at the close of the window. (See also the [Suppressed Event Aggregator](../stream-processing/suppressed-event-aggregator.md) pattern.)

## Implementation
![event-aggregator](../img/event-aggregator_a.png)

For example, we can use the streaming database [ksqlDB](https://ksqldb.io/) and Apache Kafka® to perform this aggregation.

We'll start by creating a stream in ksqlDB called `orders`, based on an existing Kafka topic of the same name:
```sql
  CREATE STREAM orders (order_id INT, item_id INT, total_units DOUBLE)
    WITH (KAFKA_TOPIC='orders', VALUE_FORMAT='AVRO');
```

Then we'll create a table containing the aggregated events from that stream:
```sql
  CREATE TABLE item_stats AS 
    SELECT item_id, COUNT(*) AS total_orders, AVG(total_units) AS avg_units
    FROM orders
    WINDOW TUMBLING (SIZE 1 HOUR)
    GROUP BY item_id 
    EMIT CHANGES;  
```

This table will be continuously updated whenever new events arrive in the `orders` stream.

## Considerations
* In event streaming, a key technical challenge is that—with few exceptions—it is generally not possible to tell whether the input data is "complete" at a given point in time. For this reason, stream processing technologies such as the streaming database [ksqlDB](https://ksqldb.io/) and the Kafka Streams client library of Apache Kafka employ techniques such as _slack time_<sup>1</sup> and _grace periods_ (see [`GRACE PERIOD`](https://docs.ksqldb.io/en/latest/concepts/time-and-windows-in-ksqldb-queries/) clause in ksqlDB) or watermarks to define cutoff points after which an [Event Processor](../event-processing/event-processor.md) will discard any late-arriving input events from its processing. See the [Suppressed Event Aggregator](../stream-processing/suppressed-event-aggregator.md) pattern for additional information.

## References
More detailed examples of event aggregation can be seen in the following tutorials: [How to sum a stream of events](https://kafka-tutorials.confluent.io/create-stateful-aggregation-sum/ksql.html) and [How to count a stream of events](https://kafka-tutorials.confluent.io/create-stateful-aggregation-count/ksql.html).

## Footnotes

<sup>1</sup>Slack time: [Beyond Analytics: The Evolution of Stream Processing Systems (SIGMOD 2020)](https://dl.acm.org/doi/abs/10.1145/3318464.3383131), [Aurora: a new model and architecture for data stream management (VLDB Journal 2003)](https://dl.acm.org/doi/10.1007/s00778-003-0095-z)
