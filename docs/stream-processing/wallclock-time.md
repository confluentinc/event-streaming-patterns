# Wallclock-Time Processing

## Problem

Consistent time semantics are important in stream processing, especially for time-based aggregations when calculating over a window of time.
Depending on the use case, the application may use the time when the event occurs (either system `wallclock` time or embedded time in the payload) or when the event is ingested.

## Solution Pattern

![wallclock-time](../img/wallclock-time.png)

Every record in ksqlDB has a system-column called `ROWTIME` that tracks the timestamp of the event.
It could be either when the event occurs (producer system time) or when the event is ingested (broker system time), depending on the `message.timestamp.type` configuration value.
ksqlDB also allows streams to use the timestamp from a field in the record payload.

## Example Implementation

By default, ksqlDB `ROWTIME` is inherited from the timestamp in the underlying Kafka record metadata, but it can also be pulled from a field in the event payload itself, as shown below.

```
CREATE STREAM TEMPERATURE_READINGS_EVENTTIME
    WITH (KAFKA_TOPIC='deviceEvents',
          VALUE_FORMAT='avro',
          TIMESTAMP='eventTime');
```

## References
* [Kafka Tutorial](https://kafka-tutorials.confluent.io/time-concepts/ksql.html): Event-time semantics
