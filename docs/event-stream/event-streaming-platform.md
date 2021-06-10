# Event Streaming Platform
Companies are rarely built on a single datastore and a single application to interact with it. Typically a company may have hundreds or thousands of applications, databases, data warehouses, or other data stores. The company's data is spread across these resources and the interconnection between them is immensely complicated. In larger enterprises, multiple lines of business can complicate the situation even further. Modern software architectures, like microservices and SAS applications, are also adding complexity as engineers are tasked with weaving the entire infastructure together cohesively.

Furthermore, companies can no longer survive without reacting to [Events](../event/event.md) within their business in real time. Customers and business partners expect immediate reactions and rich interactive applications. Today, data is in motion, and engineering teams needs to model applications to process business requirements as a stream of [Events](../event/event.md), not as data at rest sitting idly in a traditional data store.

## Problem
What architecture can we use that allows us to model everything within our business as streams of [Events](../event/event.md), creating a modern, fault tolerant, and scalable platform for building modern applications?

## Solution
![event streaming platform](../img/event-streaming-platform.png)

We can design business processes and applications around [Event Streams](../event-stream/event-stream.md). Everything from sales, orders, trades, customer experiences, sensor readings and database updates are modeled as an [Event](../event/event.md). [Events](../event/event.md) are written to the Event Streaming Platform once, allowing distributed functions within the business to react in real time to those [Events](../event/event.md). Systems external to the Event Streaming Platform are integrated using [Event Sources](../event-source/event-source.md) and [Event Sinks](../event-sink/event-sink.md). Business logic is built within [Event Processing Applications](../event-processing/event-processing-application.md) which are composed of [Event Processors](../event-processing/event-processor.md) that read and write [Events](../event/even.md) from [Event Streams](../event-stream/event-stream.md).

## Implementation

## Considerations 

## References
* This pattern is derived from [Message Bus](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageBus.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf

