# Timestamp Assigner

Consistent time semantics are of particular importance in stream processing. Many operations in an [Event Processor](TODO: link) are dependent on time, such as joins, aggregations when computed over a window of time (e.g., 5-minute averages), and the handling out-of-order and "late" data. In many systems, developers have the choice between different variants of time for an event: (1) event-time, which captures the time at which an event was originally created by its [Event Source](TODO: link), (2) ingestion-time, which captures the time an event was received on the event stream in an [Event Streaming Platform](TODO: link), and (3) wallclock-time or processing-time, which is the time at which a downstream [Event Processor](TODO: link) happens to process the event (which can be milliseconds, hours, months, etc. after event-time) . Depending on the use case, developers need to pick one variant over the others.

## Problem

How do I extract the timestamp embedded in the event content?

## Solution Pattern

![timestamp-assigner](../img/timestamp-assigner.png)

Implement a timestamp-extractor in the event processing application that understands the structure of the event payload and knows which field to extract to use for the timestamp.  Since the event processing application will most likely use a `Long` datatype to represent the timestamp and the field could be stored as a `Long` value or a logical `Date` type the timestamp-extractor implementation should convert the extracted value to a `Long` before returning it to the event processing application.

## Implementation

Every record in ksqlDB has system-column named `ROWTIME` representing the timestamp for the event.  The `ROWTIME` column gets the timestamp from the underlying `ConsumerRecord`.  To use a timestamp in the event payload itself you can add a `WITH(TIMESTAMP='some-field')` which instructs ksqlDB to then get the timestamp from the specified field in the record.

```
CREATE STREAM MY_EVENT_STREM
    WITH (KAFKA_TOPIC='events',
          TIMESTAMP='eventTime');

```

## Considerations

When using the `WITH(TIMESTAMP='some-field)` clause the underlying field needs to be a type of `Long` (64-bit) representing a Unix epoch time in milliseconds.  If the event stores the timestamp as a `Date` or `Instant`, you'll need to implement a user-defined-function (UDF) that can covert the field from its stored format to the required `Long` one.

## References

* [Timestamp assignment in ksqlDB](https://docs.ksqldb.io/en/latest/concepts/time-and-windows-in-ksqldb-queries/#timestamp-assignment)
* [Kafka Tutorials]( https://kafka-tutorials.confluent.io/time-concepts/ksql.html): Time concepts