---
seo:
  title: Event Stream Merger
  description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec rhoncus aliquet consequat. Morbi nec lorem eget mauris posuere consequat in vel sem. Nunc ut malesuada est, fermentum tristique velit. In in odio dui. Nunc sed iaculis mauris. Donec purus tellus, fringilla nec tempor et, tristique sit amet nulla. In pharetra ligula orci, eget mattis odio luctus eu. Praesent porttitor pretium dolor, ut facilisis tortor dignissim vitae.
---

# Event Stream Merger
An [Event Streaming Application](../event-processing/event-processing-application.md) may contain multiple [Event Stream](../event-stream/event-stream.md) instances.  But in some cases it may make sense for the application to merge the different event streams into a single event stream, without changing the individual events.  While this may seem logically related to a join, the merge is a completely different operation.  A join produces results by combining events with the same key to produce a new event, possibly of a different type.  Whereas the merge combines the events from multiple streams into a single stream, but the individual events are unchanged and remain independent of each other.  

## Problem
How can an application merge different event streams?

## Solution
![event-stream-merger](../img/event-stream-merger.png)


## Implementation
The Kafka Streams DSL provides a `merge` operator which merges two streams into a single stream. You can then take the merged stream and use any number of operations on it.

```java
KStream<String, Event> eventStream = builder.stream(...);
KStream<String, Event> eventStreamII = builder.stream(...);
KStream<String, Event> allEventsStream = eventStream.merge(eventStreamII);

allEventsStream.groupByKey()...
```

## Considerations

* Kafka Streams provides no guarantees on the processing order of records from the underlying streams.
* When merging streams the key and value types must be the same.

## References
* [Kafka Tutorial](https://kafka-tutorials.confluent.io/merge-many-streams-into-one-stream/kstreams.html): Merging with Kafka Streams.
* [Kafka Tutorial](https://kafka-tutorials.confluent.io/merge-many-streams-into-one-stream/ksql.html): Merging streams with ksqlDB.


