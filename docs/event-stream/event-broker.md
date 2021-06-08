# Event Broker
Loosely coupled components allow my applications to change with minimal impact on dependent systems. This loose coupling also allows my development teams to efficiently work asynchronously with respect to one another. 

## Problem
How can I decouple [Event Sources](../event-source/event-source.md) from [Event Sinks](../event-sink/event-sink.md), both of which may include cloud services, systems like relational databases, as well as applications and microservices?

## Solution
![event-broker](../img/event-broker.png)

We use the Event Broker of an [Event Streaming Platform](../event-stream/event-streaming-platform.md) for this decoupling. Typically, multiple such brokers are deployed as a distributed cluster to ensure elasticity, scalability, and fault-tolerance during operations.  Event brokers collaborate on receiving and durably storing (write operations) as well as serving (read operations) [Events](../event/event.md) into [Event Streams](../event-stream/event-streams.md) from one or many clients in parallel. Clients that produce events are called the [Event Sources](../event-source/event-source.md), which are decoupled and isolated through the brokers from the clients that consume events, called the [Event Sinks](../event-sink/event-sink.md). 

Typically, the technical architecture follows the design of "dumb brokers, smart clients". Here, the broker intentionally limits its client-facing functionality to achieve the best performance and scalability. This means that additional work has to be performed by the broker's clients. For example, unlike in traditional messaging brokers, it is the responsibility of an event sink (consumer) to track its individual progress of reading and processing from an event stream.

## Implementation
[Apache Kafka](https://kafka.apache.org/) is an open-source distributed [Event Streaming Platform](../event-stream/event-streaming-platform.md) which implements this Event Broker pattern. Kafka runs as a highly scalable and fault-tolerant cluster of brokers. In parallel, [Event Processing Applications](../event-processing/event-processing-application.md) produce, consume, and process Events from the cluster using a loosely coupled but coordinated design.

## Considerations
* Counter to traditional message brokers, Event Brokers provide a data persistence layer that allows client applications to initiate and resume Event production and consumption independently. 

## References
* This pattern is derived from [Message Broker](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageBroker.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
