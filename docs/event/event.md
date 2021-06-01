# Event
Events represent facts and can help facilitate decoupled applications, services, and systems exchanging data across an [Event Streaming Platform](../event-stream/event-streaming-platform.md).

## Problem
How do I represent a fact about something that has happened?

## Solution
![event](../img/event.png)
An event represents an immutable fact about something that happened. It is produced to, stored in, and consumed from an [Event Stream](../event-stream/event-stream.md). An event typically contains at least one or more data fields that describe the fact, as well as a timestamp that denotes when this event was created by its [Event Source](TODO: link). The event may also contain various metadata about itself, such as its source of origin (e.g., the application or cloud services that created the event) and storage-level information (e.g., its position in the event stream).

## Considerations
* To ensure that Events from an Event Source can be read correctly by an [Event Processor](../event-processing/event-processor.md), they are often created in reference to an Event schema.

* Event Schemas are commonly defined in [Avro](https://avro.apache.org/docs/current/spec.html), [Protobuf](https://developers.google.com/protocol-buffers), or [JSON schema](https://json-schema.org/).

* For cloud-based architectures, you may want to evaluate the use of [CloudEvents](https://cloudevents.io/). CloudEvent provides a standardized envelope that wraps event, making common event properties such as source, type, time, ID, and more, universally accessible, regardless of how the event itself was serialized.

* In certain scenarios, events may represent commands (think: instructions, actions) that an Event Processor reading the events should carry out. See the [Command Event](TODO: link to pattern) for details.

## References
* This pattern is derived in part from [Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Message.html), [Event Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/EventMessage.html), and [Document Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/DocumentMessage.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
