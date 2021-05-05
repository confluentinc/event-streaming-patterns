---
seo:
  title: Event Processing Application
  description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec rhoncus aliquet consequat. Morbi nec lorem eget mauris posuere consequat in vel sem. Nunc ut malesuada est, fermentum tristique velit. In in odio dui. Nunc sed iaculis mauris. Donec purus tellus, fringilla nec tempor et, tristique sit amet nulla. In pharetra ligula orci, eget mattis odio luctus eu. Praesent porttitor pretium dolor, ut facilisis tortor dignissim vitae.
---

# Event Processing Application
An Event Processing Application uses one or more [Event Processor](event-processor.md) instances to handle streaming event driven data.

## Problem
How can I build an application to work with streaming event data?

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


