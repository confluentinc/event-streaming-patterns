# Event
Events represent facts and can help facilitate two decoupled applications exchanging data across an [Event Streaming Platform](../event-stream/event-streaming-platform.md).

## Problem
How do I represent a fact about something that has happened?

## Solution
![event](../img/event.png)
An event represents an immutable fact about something that happened. It is produced to, stored in, and consumed from an [Event Stream](../event-stream/event-stream.md). An event typically contains at least one or more data fields that describe the fact, as well as a timestamp that denotes when this event was created by its [Event Source](TODO: link). The event may also contain various metadata about itself, such as its source of origin (e.g., the application or cloud services that created the event) and storage-level information (e.g., its position in the event stream).

## Considerations
Events are often created in reference to a schema (TODO:pattern-ref) commonly defined in [Avro](https://avro.apache.org/docs/current/spec.html), [Protobuf](https://developers.google.com/protocol-buffers), or [JSON schema](https://json-schema.org/). The emerging standard: [Cloud Events](https://cloudevents.io/) provides a standardized envelope that wraps event data, making common event properties such as source, type, time, ID, and more, universally accessible regardless of the event payload. 
While events are necessarily a 'fact', in many cases they also imply movement: the communicating of facts about the world from one piece of software to another. 

## References
* This pattern is derived in part from [Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Message.html), [Event Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/EventMessage.html), and [Document Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/DocumentMessage.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
