# Event-Time Processing

Consistent time semantics are of particular importance in stream processing. Many operations in an [Event Processor](../event-processing/event-processor.md) are dependent on time, such as joins, aggregations when computed over a window of time (e.g., 5-minute averages), and the handling out-of-order and "late" data. In many systems, developers have the choice between different variants of time for an event: 

1. Event-time, which captures the time at which an event was originally created by its [Event Source](../event-source/event-source.md).
2. Ingestion-time, which captures the time an event was received on the event stream in an [Event Streaming Platform](../event-processing/event-processing-application.md).
3. Wallclock-time or processing-time, which is the time at which a downstream [Event Processor](../event-processing/event-processor.md) happens to process the event (which can be milliseconds, hours, months, etc. after event-time) .
Depending on the use case, developers need to pick one variant over the others.

## Problem

How do I extract an event's timestamp from a field of the event, i.e., from its payload?

## Solution

![event-time-processing](../img/event-time-processing.png)

For event-time processing, you'll need to implement a [Timestamp Assigner](timestamp-assigner.md) that will extract the timestamp of when the event was originally created at the [Event Source](../event-source/event-source.md)

## Implementation

In the streaming database ksqlDB, every event/record has a system-column named `ROWTIME` representing the timestamp for the event, which defaults to the time at which the event was originally created by its [Event Source](../event-source/event-source.md).
To use a timestamp in the event payload itself, we can add a `WITH(TIMESTAMP='some-field')` clause when creating a stream or table, which instructs ksqlDB to then get the timestamp from the specified field in the record:

```
CREATE STREAM my_event_stream
    WITH (kafka_topic='events',
          timestamp='eventTime');

```

This also works when reading events from an existing Kafka topic into a `STREAM` or `TABLE` in ksqlDB, which makes it easy to integrate data from other applications that are not using ksqlDB themselves.

Additionally, Kafka has the notion of event-time vs. processing-time (wallclock) vs. ingestion time, similar to ksqlDB.  Clients like Kafka Streams make it possible to select which variant of time you want to work with in your application.

## Considerations

When considering which time semantics to use, it comes down to the problem domain. In most cases, event-time processing is the recommended option. For example, when re-processing historical event streams (such as for A/B testing, for training machine learning models), only event-time yields correct processing results. If we use processing-time (wall-clock time) to process the last four weeks of events, then an [Event Processor](../event-processing/event-processor.md) will falsely believe that these four weeks of data were created just now in a matter of minutes, which totally breaks the original timeline and temporal distribution of the data and thus leads to incorrect processing results.

The difference of event-time to ingestion-time is typically less pronounced than to processing-time as described above, but ingestion-time still suffers from the same conceptual discrepancy between when an event actually occurred in the real world (event-time) vs. when the event was received and stored in the [Event Streaming Platform](../event-processing/event-processing-application.md) (ingestion-time). If, for some reason, there is a significant delay between event capture and delivery to the [Event Streaming Platform](../event-processing/event-processing-application.md), then event-time is the better option.

One reason not to use event-time is when we cannot trust the [Event Source](../event-source/event-source.md) to provide us with reliable data, which includes the embedded timestamps of events. In this case, ingestion-time can become the preferred option, if fixing the root cause (unreliable event sources) is not a feasible option.

## References

* [Timestamp assignment in ksqlDB](https://docs.ksqldb.io/en/latest/concepts/time-and-windows-in-ksqldb-queries/#timestamp-assignment)
* See the tutorial [Event-time semantics in ksqlDB]( https://kafka-tutorials.confluent.io/time-concepts/ksql.html) for further details on time concepts
