# Correlation Identifier
[Event Processing Applications](../event-processing/event-processing-application.md) may want to implement an [Event Collaboration](../compositional-patterns/event-collaboration.md) pattern where [Events](../event/event.md) will serve as both requests and responses. Decoupled [Event Processors](../event-processing/event-processor.md) will need to be able to asynchronously correlate Events.

## Problem
How does an application that has requested information and received a reply know which request this is the reply for?

## Solution
![correlation-identifier](../img/correlation-identifier.png)

Add a globally unique identifier to an Event that acts as the request. When a responding Event Processor generates a response Event, it attaches the corresponding identifier to the response Event allowing the requesting processor to correlate the request and response Events.

## Considerations
TODO: Technology specific reflection on implementing the pattern 'in the real world'. Considerations may include optional subsequent decisions or consequences of implementing the pattern.

## References
* This pattern is derived from [Correlation Identifier](https://www.enterpriseintegrationpatterns.com/patterns/messaging/CorrelationIdentifier.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* For a case study on coordinating microservices twoards higher level business goals, see [Building a Microservices Ecosystem with Kafka Streams and ksqlDB](https://www.confluent.io/blog/building-a-microservices-ecosystem-with-kafka-streams-and-ksql/)
* Correlation Identifiers can be used as part of [Event Collaboration](../compositional-patterns/event-collaboration.md), a pattern in which decentralized Event Processing Applications collaborate to implement a distributed workflow solution.

