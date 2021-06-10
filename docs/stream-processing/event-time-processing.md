# Event-Time Processing

Consistent time semantics are of particular importance in stream processing. Many operations in an [Event Processor](../event-processing/event-processor.md) are dependent on time, such as joins, aggregations when computed over a window of time (e.g., 5-minute averages), and the handling out-of-order and "late" data. In many systems, developers have the choice between different variants of time for an event: 
1. Event-time, which captures the time at which an event was originally created by its [Event Source](../event-source/event-source.md).
2. Ingestion-time, which captures the time an event was received on the event stream in an [Event Streaming Platform](../event-processing/event-processing-application.md).
3. Wallclock-time or processing-time, which is the time at which a downstream [Event Processor](../event-processing/event-processor.md) happens to process the event (which can be milliseconds, hours, months, etc. after event-time) .
Depending on the use case, developers need to pick one variant over the others.

## Problem

How do I extract an event's timestamp from a field of the event, i.e., from its payload?

## Solution

![event-time-processing](../img/timestamp-assigner.png)

For event-time processing, you'll need to implement a [Timestamp Assigner](timestamp-assigner.md) that will extract the timestamp of when the event was originally created at the [Event Source](../event-source/event-source.md)

## Implementation

Every event/record in ksqlDB has system-column named `ROWTIME` representing the timestamp for the event, which defaults to the time at which the event was originally created by its [Event Source](../event-source/event-source.md).
To use a timestamp in the event payload itself, we can add a `WITH(TIMESTAMP='some-field')` clause when creating a stream or table, which instructs ksqlDB to then get the timestamp from the specified field in the record:

```
CREATE STREAM my_event_stream
    WITH (kafka_topic='events',
          timestamp='eventTime');

```

Additionally, Kafka has the notion of event-time vs. processing-time (wallclock) vs. ingestion time, similar to ksqlDB.  Clients like Kafka Streams make it possible to select which variant of time you want to work with in your application.

## Considerations

When considering which time semantics to use, it comes down to the problem domain.  In most cases, the difference between event-time and ingestion-time should be minimal.  The same could be said for processing time as well.  But there are some business domains where specific event-time is critical.  Consider financial services, for example, where even a few milliseconds can significantly impact business outcomes.  It also depends on your event processing infrastructure.  If, for some reason, there is a significant delay between event capture and delivery to the [Event Streaming Platform](../event-processing/event-processing-application.md), then using event-time would seem to be a better option.

## References

* [Timestamp assignment in ksqlDB](https://docs.ksqldb.io/en/latest/concepts/time-and-windows-in-ksqldb-queries/#timestamp-assignment)
* See the tutorial [Event-time semantics in ksqlDB]( https://kafka-tutorials.confluent.io/time-concepts/ksql.html) for further details on time concepts
