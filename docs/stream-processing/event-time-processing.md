---
seo:
  title: Event-Time Processing
  description: Event-Time Processing allows an Event Streaming Application to process an Event with the timestamp of when the Event originally occurred. 
---

# Event-Time Processing

Consistent time semantics are of particular importance in stream processing. Many operations in an [Event Processor](../event-processing/event-processor.md) are dependent on time, such as joins, aggregations when computed over a window of time (for example, five-minute averages), and handling out-of-order and "late" data. In many systems, developers have a choice between different variants of time for an Event: 

1. Event-time, which captures the time at which an Event was originally created by its [Event Source](../event-source/event-source.md).
2. Ingestion-time, which captures the time at which an Event was received on the Event Stream in an [Event Streaming Platform](../event-processing/event-processing-application.md).
3. Wall-clock-time or processing-time, which is the time at which a downstream [Event Processor](../event-processing/event-processor.md) happens to process the Event (potentially milliseconds, hours, months, or more after event-time).

Depending on the use case, developers need to pick one variant over the others.

## Problem

How can we implement event-time based processing of Events (i.e., processing based on each Event's original timeline)?

## Solution

![event-time-processing](../img/event-time-processing.png)

For event-time processing, the [Event Source](../event-source/event-source.md) must include a timestamp in each Event (for example, in a data field or in header metadata) that denotes the time at which the Event was created by the Event Source. Then, on the consuming side, the [Event Processing Application](../event-processing/event-processing-application.md) needs to extract this timestamp from the Event. This allows the application to process Events based on their original timeline.

## Implementation

### ksqlDB

In the streaming database [ksqlDB](https://ksqldb.io/), every Event (or record) has a system column named `ROWTIME`, which represents the timestamp for the Event. This defaults to the time at which the Event was originally created by its [Event Source](../event-source/event-source.md). For example, when we create a ksqlDB `STREAM` or `TABLE` from an existing Apache Kafka® topic, then the timestamp embedded in a Kafka message is extracted and assigned to the Event in ksqlDB. (See also the [CreateTime of a Kafka `ProducerRecord`](https://kafka.apache.org/28/javadoc/org/apache/kafka/clients/producer/ProducerRecord.html), and the [Kafka message format](http://kafka.apache.org/protocol.html).)

Sometimes, this default behavior of ksqlDB is not what we want. Maybe the Events have a custom data field containing their actual timestamps (for example, some legacy data that has been around for a while was ingested into Kafka only recently, so we can't trust the `CreateTime` information in the Kafka messages because they are much newer than the original timestamps). To use a timestamp in the Event payload itself, we can add a `WITH(TIMESTAMP='some-field')` clause when creating a stream or table. This instructs ksqlDB to get the timestamp from the specified field in the record.

```sql
CREATE STREAM my_event_stream
    WITH (kafka_topic='events',
          timestamp='eventTime');

```

### Kafka Streams

The Kafka Streams client library of Apache Kafka provides a `TimestampExtractor` interface for extracting the timestamp from Events. The default implementation retrieves the timestamp from the Kafka message (see the discussion above) as set by the producer of the message. Normally, this setup results in event-time processing, which is what we want.

But for those cases where we need to get the timestamp from the event payload, we can create our own `TimestampExtractor` implementation:

```java
class OrderTimestampExtractor implements TimestampExtractor {
@Override
public long extract(ConsumerRecord<Object, Object> record, long partitionTime) {
    ElectronicOrder order = (ElectronicOrder)record.value();
    return order.getTime();
}

```

Generally speaking, this functionality of custom timestamp assignment makes it easy to integrate data from other applications that are not using Kafka Streams or ksqlDB themselves.

Additionally, Kafka has the notion of event-time vs. processing-time (wall-clock-time) vs. ingestion time, similar to ksqlDB. Clients such as Kafka Streams make it possible to select which variant of time we want to work with in our application.

## Considerations

When deciding which time semantics to use, we need to consider the problem domain. In most cases, event-time processing is the recommended option. For example, when re-processing historical Event Streams (such as for A/B testing, for training machine learning models), only event-time processing yields correct results. If we use processing-time (wall-clock time) to process the last four weeks' worth of Events, then an [Event Processor](../event-processing/event-processor.md) will falsely believe that these four weeks of data were created just now in a matter of minutes, which completely breaks the original timeline and temporal distribution of the data and thus leads to incorrect processing results.

The difference between event-time and ingestion-time is typically less pronounced, but ingestion-time still suffers from the same conceptual discrepancy between when an Event actually occurred in the real world (event-time) vs. when the Event was received and stored in the [Event Streaming Platform](../event-processing/event-processing-application.md) (ingestion-time). If, for some reason, there is a significant delay between when an Event is captured and when it is delivered to the Event Streaming Platform, then event-time is the better option.

One reason not to use event-time is if we cannot trust the [Event Source](../event-source/event-source.md) to provide us with reliable data, including reliable embedded timestamps for Events. In this case, ingestion-time may be the preferred option, if it is not feasible to fix the root cause (unreliable Event sources).

## References
* See also the [Wall-Clock-Time Processing](../stream-processing/wallclock-time.md) pattern, which provides further details about using current time (wall-clock time) as the event time.
* [Timestamp assignment in ksqlDB](https://docs.ksqldb.io/en/latest/concepts/time-and-windows-in-ksqldb-queries/#timestamp-assignment)
* See the tutorial [Event-time semantics in ksqlDB](https://kafka-tutorials.confluent.io/time-concepts/ksql.html) for further details about time concepts.
