---
seo:
  title: Correlation Identifier
  description: The Correlation Identifier enables request response protocols on top of Event Streaming platforms, such as Apache Kafka®.
---

# Correlation Identifier
[Event Processing Applications](../event-processing/event-processing-application.md) may want to implement [Event Collaboration](../compositional-patterns/event-collaboration.md), where [Events](../event/event.md) are used to transport requests and responses. When applications collaborate via events, they need a way to correlate event response data for specific requests.

## Problem
When an application requests information and receives a response, how can the application know which request corresponds to that particular response?

## Solution
![correlation-identifier](../img/correlation-identifier.svg)

An [Event Processor](../event-processing/event-processor.md) generates an event, which acts as the request. A globally unique identifier is added to the request event before it is sent. This allows the responding Event Processor to include the identifier in the response event, so that the requesting processor can correlate the request and response.

## Implementation
In Kafka, we can add a globally unique identifier to Kafka record headers when producing a request event. The following example uses the Kafka Java producer client.
```java
ProducerRecord<String, String> requestEvent = new ProducerRecord<>("request-event-key", "request-event-value"); 
requestEvent.headers().add("requestID", UUID.randomUUID().toString());
requestEvent.send(producerRecord);
```

In the responding event processor, we first extract the correlation identifier from the request event (here, the identifier is called `requestID`) and then add that identifier to the response event.
```Java
ProducerRecord<String, String> responseEvent = new ProducerRecord<>("response-event-key", "response-event-value"); 
requestEvent.headers().add("requestID", requestEvent.headers().lastHeader("requestID").value());
requestEvent.send(producerRecord);
```

## References
* This pattern is derived from [Correlation Identifier](https://www.enterpriseintegrationpatterns.com/patterns/messaging/CorrelationIdentifier.html) in _Enterprise Integration Patterns_, by Gregor Hohpe and Bobby Woolf.
* For a case study on coordinating microservices towards higher-level business goals, see [Building a Microservices Ecosystem with Kafka Streams and ksqlDB](https://www.confluent.io/blog/building-a-microservices-ecosystem-with-kafka-streams-and-ksql/).
* Correlation identifiers can be used as part of [Event Collaboration](../compositional-patterns/event-collaboration.md), a pattern in which decentralized Event Processing Applications collaborate to implement a distributed workflow solution.
* The idea of tagging requests and their associated responses exists in many other protocols. For example, an email client [connecting over IMAP](https://datatracker.ietf.org/doc/html/rfc3501#section-2.2.1) will send commands prefixed with a unique ID (typically `a001`, `a002`, etc.), and the server will respond asynchronously, tagging its responses with the matching ID.
