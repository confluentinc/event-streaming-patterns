---
seo:
  title: Suppressed Event Aggregator
  description: The Suppressed Event Aggregator performs an aggregation across a continuous Event Stream of multiple related Events and produces a new Event.
---

# Suppressed Event Aggregator
An [Event Streaming Application](../event-processing/event-processing-application.md) can perform continuous aggregation operations using an [Event Aggregator](event-aggregator.md).  If the input data is not windowed (cf. the [Event Grouper](../stream-processing/event-grouper.md) pattern), the aggregator will emit "intermediate" processing results. That's because an Event Stream is potentially infinite, so generally we do not know when the input is considered "complete." So, with few exceptions, there isn't really a point at which we can have a "final" result.

However, if the input data is windowed (for example, if the input is grouped into five-minute windows in order to compute five-minute averages), then it is possible to emit a "final" result per window. In this case, the aggregator knows when the input for a given window is considered complete, and thus it can be configured to suppress "intermediate" results until the window time passes.


## Problem
How can an Event Aggregator provide a final aggregation result, rather than only "intermediate" results that are continuously updated?

## Solution
![suppressed-event-aggregator](../img/suppressed-event-aggregator.png)

First, the input Events of the aggregator must be windowed using an [Event Grouper](../stream-processing/event-grouper.md): the Events are grouped into "windows" based on their timestamps. Depending on the configured grouping, an Event can be placed exclusively into a single window, or it can be placed into multiple windows.
Then, the Event Aggregator performs its operation on each window.

Only once the window is considered to have "passed" will the aggregator output a single, final result for this window. For example, consider an aggregation for an Event Stream of customer payments, where we want to compute the number of payments per hour.  By using a window size of one hour, we can emit a final count for the hourly number of payments after the respective one-hour window closes.

Ideally, the aggregator is able to handle out-of-order or "late" Events, which is a common situation in an Event Streaming Platform (for example, an Event created at 9:03 am arrives at 9:07 am). Here, a common technique is to let users define a so-called _grace period_ for windows, to give delayed Events some extra time to arrive. Events that arrive within the grace period of a window will be processed, whereas any later Events will be not be processed (for example, if the grace period is three minutes, then the 9:03 am Event arriving at 9:07 am would be included in the 9:00-9:05 am window; any Events arriving at or after 9:08 am would be ignored by this window). 

Note that the use of a grace period increases the processing latency, because the aggregator has to wait for an additional period of time before it knows that the input for a given window is complete and thus can output the single, final result for that window.


## Implementation
For Apache Kafka®, the [Kafka Streams client library](https://docs.confluent.io/platform/current/streams/index.html) provides a `suppress` operator in its DSL. We can apply this operator to windowed aggregations.

In the following example, we compute hourly aggregations on a stream of orders, using a grace period of five minutes to wait for any orders arriving with a slight delay. The `suppress` operator ensures that there is only a single result Event for each hourly window.

```java
KStream<String, OrderEvent> orderStream = builder.stream(...);

 orderStream.groupByKey()
            .windowedBy(TimeWindows.of(Duration.ofHours(1)).grace(Duration.ofMinutes(5)))
            .aggregate(() -> 0.0 /* initial value of `total`, per window */,
                       (key, order, total) -> total + order.getPrice(),
                       Materialized.with(Serdes.String(), Serdes.Double()))
            .suppress(untilWindowCloses(unbounded()))
            .toStream()
            .map((windowKey, value) -> KeyValue.pair(windowKey.key(),value))
            .to(outputTopic, Produced.with(Serdes.String(), Serdes.Double()));
```

## Considerations

* In order to honor the contract of outputting only a single result per window, the Suppressed Event Aggregator typically buffers Events in some way until the window closes. If the Suppressed Event Aggregator implementation uses an in-memory buffer, then depending on the number of Events per window and the payload size of each Event, you may encounter out-of-memory errors.

## References
* The tutorial [Emit a final result from a time window with Kafka Streams](https://kafka-tutorials.confluent.io/window-final-result/kstreams.html) provides more details about the `suppress` operator of the Kafka Streams DSL.
