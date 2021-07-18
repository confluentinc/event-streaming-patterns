---
seo:
  title: Event Standardizer
  description: An Event Standardizer converts events in multiple formats to a common format understood by a downstream event processor.
---

# Event Standardizer
In most businesses, a variety of traditional and [Event Processing Applications](../event-processing/event-processing-application.md) need to exchange [Events](../event/event.md) across [Event Streams](../event-stream/event-stream.md). Downstream Event Processing Applications will require standardized data formats in order to properly process these events. However, the reality of having many sources for these events often leads to a lack of such standards, or to different interpretations of the same standard.

## Problem
How can I process events that are semantically equivalent but arrive in different formats?

## Solution
![event-standardizer](../img/event-standardizer.png)
Source all of the input Event Streams into an Event Standardizer that passes events to a specialized [Event Translator](../event-processing/event-translator.md), which in turn converts the events into a common format understood by the downstream [Event Processors](../event-processing/event-processor.md).

## Implementation
As an example, we can use the [Kafka Streams client library](https://docs.confluent.io/platform/current/streams/index.html) of Apache Kafka® to build an Event Processing Application that reads from multiple input Event Streams and then maps the values to a new type. Specifically, we can use the `mapValues` function to translate each event type into the standard type expected on the output [Event Stream](../event-stream/event-stream.md).

```
SpecificAvroSerde<SpecificRecord> inputValueSerde = constructSerde();

builder
  .stream(List.of("inputStreamA", "inputStreamB", "inputStreamC"),
    Consumed.with(Serdes.String(), inputValueSerde))
  .mapValues((eventKey, eventValue) -> {
    if (eventValue.getClass() == TypeA.class)
      return typeATranslator.normalize(eventValue);
    else if (eventValue.getClass() == TypeB.class)
      return typeBTranslator.normalize(eventValue);
    else if (eventValue.getClass() == TypeC.class)
      return typeCTranslator.normalize(eventValue);
    else {
      // exception or dead letter stream
    }
  })
  .to("my-standardized-output-stream", Produced.with(Serdes.String(), outputSerdeType));
```

## Considerations
* When possible, diverging data formats should be normalized "at the source". This data governance is often called "Schema on Write", and may be implemented using the [Schema Validator](../event-source/schema-validator.md) pattern. Enforcing schema validation prior to writing an event to the Event Stream allows consuming applications to delegate their data format validation logic to the schema validation layer.
* Error handling should be considered in the design of the standardizer. Categories of errors may include serialization failures, unexpected or missing values, and unknown types (as in the example above). [Dead Letter Stream](../event-processing/dead-letter-stream.md) is one pattern commonly used to handle exceptional events in the Event Processing Application. 


## References
* See also the [Stream Merger](../stream-processing/event-stream-merger.md) pattern, for unifying related streams _without_ changing their format.
* This pattern is derived from [Normalizer](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Normalizer.html) in _Enterprise Integration Patterns_, by Gregor Hohpe and Bobby Woolf.
* Kafka Streams [`map` stateless transformation](https://docs.confluent.io/platform/current/streams/developer-guide/dsl-api.html#creating-source-streams-from-ak) documentation
* [Error Handling Patterns for Apache Kafka Applications](https://www.confluent.io/blog/error-handling-patterns-in-kafka/) is a blog post with details on strategies and patterns for error handling in [Event Processing Applications](../event-processing/event-processing-application.md)
