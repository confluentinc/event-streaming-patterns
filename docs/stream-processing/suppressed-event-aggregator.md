
# Suppressed Event Aggregator
An [Event Streaming Application](../event-processing/event-processing-application.md) can provide aggregation operations like an [Event Aggregator](event-aggregator.md).  If not windowed, the event-aggregator will emit intermediate results, as an event stream is infinite, so there's not really a point where you can have a final result.  However, if the aggregation is windowed i.e results are bucketed by time, then emitting a final result is possible as the event aggregator will suppress intermediate results until the window time passes.


## Problem
How can an event aggregator provide a final aggregation result?

## Solution
![suppressed-event-aggregator](../img/suppressed-event-aggregator.png)

The event aggregator should bucket the aggregations by time also known as windowing.  For example consider a aggregation for a stream monitoring a click stream.  By using a window of 1-hour, you could emit a final count for the number of clicks once the one hour window closes.


## Implementation
The Kafka Streams DSL provides a `suppress` operator that you can apply to windowed aggregations.

```java
KStream<String, OrderEvent> orderStream = builder.stream(...)

 orderStream.groupByKey()
            .windowedBy(TimeWindows.of(Duration.ofHours(1)).grace(Duration.ofMinutes(5)))
            .aggregate(() -> 0.0,
                       (key, order, total) -> total + order.getPrice(),
                       Materialized.with(Serdes.String(), Serdes.Double()))
            .suppress(untilWindowCloses(unbounded()))
            .toStream()
            .map((wk, value) -> KeyValue.pair(wk.key(),value))
            .to(outputTopic, Produced.with(Serdes.String(), Serdes.Double()));
```

## Considerations

* When creating a time window with suppress you should define a grace period as the default grace period is 24 hours
* To not violate the constraint of a single final output when the window closes, the suppressed operator buffers events until the window closes.  Depending on the number of events and their size the buffer will consume memory possibly causing an OOM error.
* If your Kafka Streams application is running in a memory constrained environment consider using the `untilTimeLimit` method which will allow for emitting an early record should the buffer reach a configured maximum size.

## References
* [Kafka Tutorial](https://kafka-tutorials.confluent.io/window-final-result/kstreams.html): Emit a final result from a time window



