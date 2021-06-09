---
seo:
  title: Event Processing Application
  description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec rhoncus aliquet consequat. Morbi nec lorem eget mauris posuere consequat in vel sem. Nunc ut malesuada est, fermentum tristique velit. In in odio dui. Nunc sed iaculis mauris. Donec purus tellus, fringilla nec tempor et, tristique sit amet nulla. In pharetra ligula orci, eget mattis odio luctus eu. Praesent porttitor pretium dolor, ut facilisis tortor dignissim vitae.
---

# Event Processing Application
To create, read, process, and/or query the data in an [Event Streaming Platform](../event-stream/event-streaming-platform.md), developers typically implement Event Processing Applications (e.g., in the form of microservices).

## Problem
How can we build an application for data in motion that creates, reads, processes, and/or queries [Event Streams](../event-stream/event-stream.md)?

## Solution
![event-processing-application](../img/event-processing-application.png)

We build an event processing application by composing one or more [Event Processors](../event-processing/event-processor.md) into an interconnected processing topology for [Event Streams](../event-stream/event-stream.md) and [Tables](../table/state-table.md). Here, the continuous output streams of one processor are the continuous input streams to one or more downstream processors. The event processors—and thus the application at large—are typically distributed (running across multiple instances) to allow for elastic, parallel, fault-tolerant processing of data in motion at scale.

For example, an application can read a stream of customer payments from an [Event Store](../event-storage/event-store.md) in an Event Streaming Platform, then filter only payments by VIP customers, and then aggregate those VIP payments per country and per week. The processing mode is stream processing, i.e., data is continuously processed 24x7. As soon as new events are available, they are processed and propagated through the topology of event processors.

Event processing applications themselves can be composed, too, which is a common design pattern to implement event-driven architectures, powered by a fleet of applications and microservices. Here, the output of one application forms the input to one or more downstream applications. This is conceptually similar to the topology of event processors within the same application, as described above. A key difference in practice, however, is that different applications are often built by different teams inside an organization. For example, a customer-facing application built by the Payments team is continuously feeding data via event streams to an application built by the Anti-fraud team and to another application built by the Data Science team. Another difference is that event streams for an application-to-application topology are generally externalized and persisted in an [Event Store](../event-storage/event-store.md) (e.g., they Payments application writes its events into a `payments` stream) for better application decoupling and [increased network effects](https://en.wikipedia.org/wiki/Network_effect) for the respective data. In contrast, processor-to-processor communication inside the same application may opt to not externalize/persist some of their event streams for optimization purposes (e.g., the filtered stream of VIP payments in the first example above may not need to be persisted into an event store before it is being aggregated, as the filtered stream can be trivially reconstructed from the full original stream of payments).

## Implementation

```
StreamsBuilder builder = new StreamsBuilder();
KStream<String, String> stream = builder.stream("input-events");
....      

KafkaStreams kafkaStreams = new KafkaStreams(builder.build(), properties);
kafkaStreams.start() 
```

## Considerations
When building an Event Processing Application, it's important to generally confine the application to one problem domain.  While it's true the application can have any number of event processors, they should be closely related.

## References
