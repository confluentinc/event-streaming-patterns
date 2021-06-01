# Event Source 
Various components in an [Event Streaming Platform](../event-stream/event-streaming-platform.md) will generate [Events](../event/event.md). An Event Source is the generalization of these components, which can include [Event Processing Applications](../event-processing/event-processing-application.md), cloud services, databases, IoT sensors, mainframes, and more.

Conceptually, an event source is the opposite of an [Event Sink](../event-sink/event-sink.md). In practice, however, components such as an event processing application can act as both an event source and an event sink.

## Problem
How can I create Events in an Event Streaming Platform?

## Solution
![event-source](../img/event-source.png)

## Implementation
[ksqlDB](https://ksqldb.io/) provides a builtin `INSERT` syntax to directly write new Events directly to the [Event Stream](../event-stream/event-stream.md).
```
INSERT INTO foo (ROWTIME, KEY_COL, COL_A) VALUES (1510923225000, 'key', 'A');
```

## References
* [ksqlDB](https://ksqldb.io/) The event streaming database purpose-built for stream processing applications.
