---
seo:
  title: Event Envelope
  description: Event Envelope pattern allows applications with different data formats to communicate across an Event Streaming Platform
---

# Event Envelope
[Event Streaming Platforms](../event-stream/event-streaming-platform.md) allow many different types of applications to work together. Occasionally, an existing application cannot adopt its [Event](../event/event.md) format to match what is needed by other applications on the platform.

## Problem
How can we operate existing systems on the [Event Streaming Platform](../event-stream/event-streaming-platform.md) when there are specific requirements on the [Event](../event/event.md) format that the existing system does not support?

## Solution
![event-envelope](../img/event-envelope.png)

Use an Event Envelope to wrap the application data inside an envelope that conforms to the data format expected on the [Event Streaming Platform](../event-stream/event-streaming-platform.md).

## Example Implementation
Using the basic Java consumers and producers, a helper function could be used to wrap an application's immutable payload into an envelope which conforms to the expected format of the [Event Streaming Platform](../event-stream/event-streaming-platform.md).

```Java
static <T> Envelope<T> wrap(T payload, Iterable<Header> headers) {
	return new Envelope(serializer(payload), headers);
}
static <T> T unwrap(Envelope<T> envelope) {
	return envelope.payload;
}
```

## References
* This pattern is derived from [Envelope Wrapper](https://www.enterpriseintegrationpatterns.com/patterns/messaging/EnvelopeWrapper.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf 
* [How to Choose Between Strict and Dynamic Schemas](https://www.confluent.io/blog/spring-kafka-protobuf-part-1-event-data-modeling/)
* See [Cloud Events](https://cloudevents.io/) for a specification on describing event data in a common way.
