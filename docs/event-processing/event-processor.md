---
seo:
  title: Event Processor
  description: Event Processors are components of larger Event Processing Applications which applies a discrete idempotent operation on an Event. 
---

# Event Processor
An event processor is a component that reads events and processes them, and possibly writes new events as the result of its processing. As such, it may act as an [Event Source](todo: link pattern) and/or [Event Sink](todo: link pattern), and in practice often acts as both. An event processor can be distributed (i.e., multi-instance), in which case the processing of events happens concurrently across its instances.

## Problem
How do I process events in an [Event Streaming Platform](todo: link pattern)? For example, how can I process financial transactions, track shipments, analyze IoT sensors data, or generate continuous intelligence?

## Solution
![event-processor](../img/event-processor.png)
Typically, you don't define a single event processor in isolation. Instead, you define one or more event processors inside an [Event Processing Application](event-processing-application.md) that implements one particular use case end-to-end, or (e.g., in the case of microservices) a subset of the overall business logic limited to the bounded context of a particular domain. 

An event processor performs a specific task within the event processing application. You can think of it as one processing node (or processing step) of a larger processing topology. Examples are the mapping of an event type to a domain object, filtering only the important events out of an [Event Stream](todo: link pattern), enriching an event stream with additional data by joining it to another stream or database table, triggering alerts, or creating new events for consumption by other applications.

## Implementation

```
StreamsBuilder builder = new StreamsBuilder();
        KStream<String, String> stream = builder.stream("input-events");
        stream.filter((key, value)-> value.contains("special-code"))
              .mapValues(value -> to domain object)
              .to("special-output-events");
```

## Considerations

While it could be tempting to build a "multi-purpose" event processor, it's important that processor performs a discrete, idempotent action.  By building processors this way, it's easier to reason about what each processor does and by extension what the application does. 


## References
* TODO: Reference link to the EIP pattern as citation
* TODO: pointers to related patterns?
* TODO: pointers to external material?
