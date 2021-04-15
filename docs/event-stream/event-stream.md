# Event Stream
[Events](../event/event.md) will typically be categorized by some attribute and will need to be grouped in order to be processed logically by [Event Processors](../event-processing/event-processor.md). 

## Problem
How does one [Event Processing Applications](../event-processing/event-processing-application.md) communicate events to other applications in an ordered, scalable, and repliable way?

## Solution
![event-stream](../img/event-stream.png)
Event Streams are a set of events recorded in the order in which they were written. Many Event Streaming applications can produce to or consume from an event stream. Event streams can either be consumed in their entirity or events can be distributed across a set of consuming event streaming application instances. (In Apache Kafka this is called a Consumer Group.) 

## Implementation
[ksqlDB]() supports `STREAM` processing natively and creating a stream from an existing stream can be accomplished using basic declarative SQL like syntax.
```
CREATE STREAM filtered AS SELECT col1, col2, col3 FROM source_stream;
```

## References
* This pattern is derived from [Message Channel](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageChannel.html) and [Publish-Subscribe Channel](https://www.enterpriseintegrationpatterns.com/patterns/messaging/PublishSubscribeChannel.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf

