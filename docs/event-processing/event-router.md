---
seo:
   title: Event Router
   description: Event Routers are used to route Events to different Event Streams based on data or metadata values contained in each Event. 
---

# Event Router
[Event Streams](../event-stream/event-stream.md) may contain a subset of [Events](../event/event.md) which need to be processed in isolation. For example, an inventory check system may be distributed across multiple physical systems, and the target system depends on the category of the item being checked. [Event Stream Processors](../event-processing/event-processor.md) can also be optimized when processing [Event Streams](../event-stream/event-stream.md) which contain focused data as they are free from filtering of streams with irrelevant data. Additionally, there may be a desire to do crosscutting data processing where isolating [Events](../event/event.md) will allow for a cleaner separation of concerns. 

## Problem
How can we isolate [Events](../event/event.md) into a dedicated [Event Stream](../event-stream/event-stream.md) based on some attribute of the [Events](../event/event.md)?

## Solution
![event-router](../img/event-router.png)

## Implementation
With [ksqlDB](https://ksqldb.io/), continuously routing events to a different stream is as simple as using the `CREATE STREAM` syntax with the appropriate `WHERE` filter.

```
CREATE STREAM actingevents_drama AS
    SELECT NAME, TITLE
      FROM ACTINGEVENTS
      WHERE GENRE='drama';

CREATE STREAM actingevents_fantasy AS
    SELECT NAME, TITLE
      FROM ACTINGEVENTS
      WHERE GENRE='fantasy';
```

If using Kafka Streams, the provided [TopicNameExtractor](https://kafka.apache.org/27/javadoc/index.html?org/apache/kafka/streams/processor/TopicNameExtractor.html) interface can redirect events to topics.  The `TopicNameExtractor` has one method, `extract`, which accepts three parameters:

- The event key
- The event value
- The [RecordContext](https://kafka.apache.org/23/javadoc/index.html?org/apache/kafka/streams/processor/RecordContext.html), which provides access to headers, partitions, and the contextual information about the event.

You can use any of the given parameters to return the destination topic name, and Kafka Streams will complete the routing. 

```
GenreTopicExtractor implements TopicNameExtractor<String, String> {
   String extract(String key, String value, RecordContext recordContext) {
      switch (value.genre) {
        case "drama":
          return "drama-topic";
        case "fantasy":
          return "fantasy-topic";
      }
   }
}

KStream<String, String> myStream = builder.stream(...);
myStream.mapValues(..).to( new GenreTopicExtractor());
```

## Considerations
* Event Routers should not modify the Event contents and instead only provide the proper Event routing.

## References
* This pattern is derived from [Message Router](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageRouter.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* See this [Kafka Tutorial](https://kafka-tutorials.confluent.io/dynamic-output-topic/kstreams.html) for a full example of dynamically routing events at runtime

