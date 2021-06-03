# Event Splitter
Event Splitter takes a single [event](../event/events.md) and splits it into multiple events.

## Problem
How can I process an event if it contains multiple events, each of which may need to be processed in a different way?

## Solution Pattern
![event-splitter](img/event-splitter.png)
First, split the original event into multiple child event. Most event processing technologies support this operation, for example the `EXPLODE()` table function in ksqlDB or the `flatMap()` operator in Kafka Streams. Then publish one event per child event. 

## Implementation
```
KStream<Long, String> stream = ...;
KStream<String, Integer> transformed = stream.flatMap(
     // Here, we generate two output records for each input record.
     // We also change the key and value types.
     // Example: (345L, "Hello") -> ("HELLO", 1000), ("hello", 9000)
    (key, value) -> {
      List<KeyValue<String, Integer>> result = new LinkedList<>();
      result.add(KeyValue.pair(value.toUpperCase(), 1000));
      result.add(KeyValue.pair(value.toLowerCase(), 9000));
      return result;
    }
  );
```

## Considerations
* Should child events be routed to the same stream or a different stream? See [Event Router](../event-processing/event-router.md) on how to route events to different locations.
* Capacity planning and sizing: splitting the original event into N child events leads to write amplification, thereby increasing the volume of events that must be managed by the event streaming platform.
* Event Lineage: Your use case may require tracking the lineage of parent and child events. If so, ensure that the child events include a data field containing a reference to the original parent event, e.g. a unique identifier.
