# Event Router
[Event Streams](../event-stream/event-stream.md) may contain [Events](../event/event.md) which can be separated logically by some attribute. The routing of Events to dedicated Streams may allow for simplified [Event Processing](event-processor.md) and [Event Sink](../event-sink/event-sink.md) solutions.

## Problem
How can I isolate Events into a dedicated Event Stream based on some attribute of the Events?

## Solution
![event-router](../img/event-router.png)

Kafka Streams provides the [TopicNameExtractor](https://kafka.apache.org/27/javadoc/index.html?org/apache/kafka/streams/processor/TopicNameExtractor.html) interface which can redirect events to topics.  The `TopicNameExtractor` has one method, `extract`, which accepts three parameters:

- The Key of the record
- The Value of the record
- The RecordContext

You can use any or all of these three to pull the required information to route records to different topics at runtime.  The `RecordContext` provides access to the headers of the record, which can contain user provided information for routing purposes.

## Implementation
Implement a customer topic name extractor using the Kafka Streams `TopicNameExtractor` interface and provide it to the Kafka Streams `to` function while building the topology.

```
CustomExtractor implements TopicNameExtractor<String, String> {
   
   String extract(String key, String value, RecordContext recordContext) {
         // Assuming the first ten characters of the key
         // contains the information determining where 
         // Kafka Streams forwards the record.
      return key.substring(0,10);
   }

 KStream<String, String> myStream = builder.stream(...);
 myStream.mapValues(..).to( new CustomExtractor());
```

## Considerations
* Event Routers should not modify the Event contents and instead only provide the proper Event routing.

## References
* This pattern is derived from [Message Router](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageRouter.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* See this [Kafka Tutorial](https://kafka-tutorials.confluent.io/dynamic-output-topic/kstreams.html) for a full example of dynamically routing events at runtime

