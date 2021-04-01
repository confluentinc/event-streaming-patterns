# Event Filter

## Problem

How can an application discard uninteresting events?

## Solution Pattern

The Kafka Streams DSL provides a `filter` operator, where only records matching a given predicate continue to progress in the event stream.

![event-filter](event-filter.png)

## Example Implementation

```
KStream<String, Event> eventStream = builder.stream(.....);
KStream<String, Event> eventStream = ....;
eventStream.filter((key, value) -> value.eventCode() == 200)..to(...);
```

## References
* [Kafka Tutorial](https://kafka-tutorials.confluent.io/filter-a-stream-of-events/ksql.html): How to filter a stream of events 

