# Event Streaming API
Applications that connect to the [Event Streaming Platform](../event-stream/event-streaming-platform.md) need to do so in a consistent and reliable way. 

## Problem
How can my application connect to an Event Streaming Platform to send and receive [Events](../event/events.md)?

## Solution
![event-streaming-api](../img/event-streaming-api.png)

The Event Streaming Platform provides an Application Programming Interface (API) allowing applications to reliably communicate across the platform. The API provides a logical and well documented protocol which defines the message structure and data exchange methods. Higher level libraries implement these protocols allowing a variety of technologies and programming languages to interface with the platform. The highler level libraries allow the application to focus on business logic leaving the details of the platform communication to the API.

## References
* This pattern is derived from [Message Endpoint](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageEndpoint.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* The [Apache Kafka Protocol Guide](https://kafka.apache.org/protocol.html) provides details on the wire protocol implemented in Kafka.
* The [Apache Kafka API documentation](https://kafka.apache.org/documentation/#api) contains information on the variety of APIs available for reading, writing, and administering Kafka.
