# Event
Events represent facts and can help facilitate two decoupled applications exchanging data across an [Event Streaming Platform](../event-stream/event-streaming-platform.md).

## Problem
How do I represent a fact about something that has happened?

## Solution
![event](../img/event.png)
An event is an immutable fact about something that has happened. It is produced and consumed from an [Event Stream](../event-stream/event-stream.md). Events contain data, timestamps, and may contain various metadata about the event (event headers, location in the stream, etc).

## Considerations
Events are often created in reference to a schema (TODO:pattern-ref) commonly defined in [Avro](https://avro.apache.org/docs/current/spec.html), [Protobuf](https://developers.google.com/protocol-buffers), or [JSON schema](https://json-schema.org/). The emerging standard: [Cloud Events](https://cloudevents.io/) provides a standardized envelope that wraps event data, making common event properties such as source, type, time, ID, and more, universally accessible regardless of the event payload. 
While events are necessarily a 'fact', in many cases they also imply movement: the communicating of facts about the world from one piece of software to another. 

## References
* This pattern is derived in part from [Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Message.html), [Event Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/EventMessage.html), and [Document Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/DocumentMessage.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
