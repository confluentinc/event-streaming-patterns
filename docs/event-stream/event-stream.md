# Event Stream
[Events](../event/event.md) will typically be categorized by some attribute and will need to be grouped in order to be processed logically by [Event Processors](../event-processing/event-processor.md). 

## Problem
How can Events be organized such that [Event Processing Applications](../event-processing/event-processing-application.md) can consume only the relevant Events on a particular [Event Streaming Platform](../event-stream/event-streaming-platform.md).

## Solution
![event-stream](../img/event-stream.png)

Typically Event Streams are given a name along with other configurations like retention length. Events are published to the Event Streams creating a logical categorization of Events for Event Processing Applications to consume from.

## Implementation
[ksqlDB]() supports `STREAM` processing natively and creating a stream from an existing stream can be accomplished using basic declarative SQL like syntax.
```
CREATE STREAM filtered AS SELECT col1, col2, col3 FROM source_stream;
```

## References
* This pattern is derived from [Message Channel](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageChannel.html) and [Publish-Subscribe Channel](https://www.enterpriseintegrationpatterns.com/patterns/messaging/PublishSubscribeChannel.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf

