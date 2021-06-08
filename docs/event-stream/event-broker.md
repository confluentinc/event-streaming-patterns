# Event Broker
Loosely coupled components in a software architecture allow services and applications to change with minimal impact on dependent systems and applications. On the side of the organization, this loose coupling also allows different development teams to efficiently work independently from each another.

## Problem
How can we decouple [Event Sources](../event-source/event-source.md) from [Event Sinks](../event-sink/event-sink.md), both of which may include cloud services, systems like relational databases, as well as applications and microservices?

## Solution
![event-broker](../img/event-broker.png)

We use the Event Broker of an [Event Streaming Platform](../event-stream/event-streaming-platform.md) for this decoupling. Typically, multiple such brokers are deployed as a distributed cluster to ensure elasticity, scalability, and fault-tolerance during operations.  Event brokers collaborate on receiving and durably storing (write operations) as well as serving (read operations) [Events](../event/event.md) into [Event Streams](../event-stream/event-streams.md) from one or many clients in parallel. Clients that produce events are called the [Event Sources](../event-source/event-source.md), which are decoupled and isolated through the brokers from the clients that consume events, called the [Event Sinks](../event-sink/event-sink.md). 

Typically, the technical architecture follows the design of "dumb brokers, smart clients". Here, the broker intentionally limits its client-facing functionality to achieve the best performance and scalability. This means that additional work has to be performed by the broker's clients. For example, unlike in traditional messaging brokers, it is the responsibility of an event sink (consumer) to track its individual progress of reading and processing from an event stream.

## Implementation
[Apache Kafka](https://kafka.apache.org/) is an open-source distributed [Event Streaming Platform](../event-stream/event-streaming-platform.md), which implements this Event Broker pattern. Kafka runs as a highly scalable and fault-tolerant cluster of brokers. Many [Event Processing Applications](../event-processing/event-processing-application.md) can produce, consume, and process Events from the cluster in parallel with strong guarantees such as transactions, using a fully decoupled yet coordinated architecture.

Additionally, Kafka's protocol provides strong backwards and forwards compatibility guarantees between the server-side brokers and their client applications that produce, consume, and process events. For example, a cluster of brokers running an older version of Kafka can be used by client applications using a new version of Kafka. Similarly, older client applications keep working even when the cluster of brokers is upgraded to a newer version of Kafka (and Kafka also supports in-place version upgrades of clusters). This is another facet of decoupling the various components in a Kafka-based architecture, which results in even better flexibility during design and operations.

## Considerations
* Counter to traditional message brokers, event brokers provide a distributed, durable, and fault-tolerant storage layer. This has several important benefits. For instance, client applications can initiate and resume event production and consumption independently from each other. Similarly, they don't need to be connected to the brokers perpetually in order to not miss any events. When an application is taken offline for maintenance and subsequently restarted, then it will automatically resume its consumption and processing of an event stream exactly at the point where it stopped before. The strong guarantees provided by the brokers in the event streaming platform ensure that applications do not suffer from duplicate data or from data loss (e.g., missing out on events that were written during the maintenance window) in these situations, even in the face of failures such as machine or network outages. Another benefit is that client applications can "rewind the time" and re-consume historical data in event streams as often as needed. This is useful in many situations, including training and retraining models for machine learning, A/B testing, auditing and compliance, as well as fixing unexpected application errors and bugs that happened in production.

## References
* This pattern is derived from [Message Broker](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageBroker.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
