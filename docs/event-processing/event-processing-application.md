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

Using an Event Processing Application allows you to tie together indpendant event processors for working with streaming event recorods and are not aware of each other.

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
