---
seo:
  title: Event Envelope
  description: Event Envelope pattern allows applications with different data formats to communicate across an Event Streaming Platform
---

# Event Envelope
[Event Streaming Platforms](../event-stream/event-streaming-platform.md) allow many different types of applications to work together. Standardizing on several well known fields used to wrap any [Event](../event/event.md) sent through the platform can ease adoption by new [Event Streaming Applications](../event-stream/event-streaming-application.md). Envelopes provide such fields in a format that all consumers can understand, for example referencing the encryption type, schema, key, serialization format. Envelopes are analogous to protocol headers in networking (TCP-IP etc.)

## Problem
How to convey information to all participants in an [Event Streaming Platform](../event-stream/event-streaming-platform.md) independently of the event payload, e.g. how to decrypt an  [Event](../event/event.md), what schema is used, or what ID defines the uniqueness of the event?

## Solution
![event-envelope](../img/event-envelope.png)

Use an Event Envelope to wrap the event data using a standard format agreed by all participants of the [Event Streaming Platform](../event-stream/event-streaming-platform.md) or more broadly. [Cloud Events](https://cloudevents.io/)–which standardize access to ID, Schema, Key, and other common event attributes–are an industry-standard example of the Event Envelope pattern.

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
* See [Cloud Events](https://cloudevents.io/) for a specification on describing event header information in a common way.
