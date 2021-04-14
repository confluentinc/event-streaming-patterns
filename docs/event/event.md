# Event
Events represent facts and can help facilitate two decoupled applications exchanging data across an [Event Streaming Platform](../event-stream/event-streaming-platform.md).

## Problem
How do I represent a fact about something that has happened?

## Solution
![event](../img/event.png)
An event is an immutable fact about something that has happened. It is produced and consumed from an [Event Stream](../event-stream/event-stream.md). Events contain data, timestamps, and may contain various metadata about the event (event headers, location in the stream, etc).

## References
* This pattern is derived in part from [Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Message.html), [Event Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/EventMessage.html), and [Document Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/DocumentMessage.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
