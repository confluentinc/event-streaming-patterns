# Event Standardizer
In most businesses, a variety of traditional and [Event Processing Applications](../event-processing/event-processing-application.md) need to exchange [Events](../event/event.md) across [Event Streams](../event-stream/event-stream.md). Downstream [Event Processing Applications](../event-processing/event-processing-application.md) will require standardized data formats in order to properly process these [Events](../event/event.md). However, the reality of having many sources for these [Events](../event/event.md) often results in the lack of such standards or in different interpretations of the same standard.

## Problem
How do we process [Events](../event/event.md) that are semantically equivalent, but arrive in different formats?

## Solution
![event-standardizer](../img/event-standardizer.png)
Source all the input [Event Streams](../event-stream/event-stream.md) into an Event Standardizer that passes [Events](../event/event.md) to a specialized [Event Translator](../event-processing/event-translator.md), which in turn converts the [Event](../event/event.md) to a common format understood by the downstream [Event Processors](../event-processing/event-processor.md).

## Implementation
A [Kafka Streams](https://kafka.apache.org/documentation/streams/) [Toplogy](https://docs.confluent.io/platform/current/streams/architecture.html#processor-topology) can read from multiple input [Event Streams](../event-stream/event-stream.md) and `map` the values to a new type. This `mapValues` function allows us translate each [Event](../event/event.md) type into the standard type expected on the output [Event Stream](../event-stream/event-stream.md).

```
SpecificAvroSerde<SpecificRecord> inputValueSerde = constructSerde();
builder
  .stream(List.of("inputStreamA", "inputStreamB", "inputStreamC"),
    Consumed.with(Serdes.String(), inputValueSerde))
  .mapValues((k, v) -> {
    if (v.getClass() == TypeA.class)
      return typeATranslator.normalize(v);
    else if (v.getClass() == TypeB.class)
      return typeBTranslator.normalize(v);
    else if (v.getClass() == TypeC.class)
      return typeCTranslator.normalize(v);
    else {
      // exception or dead letter stream
    }
  })
  .to("outputStream", Produced.with(Serdes.String(), outputSerdeType));
```

## Considerations
When possible, diverging data format should be normalized "at the source". This data governence is often called "Schema on Write", and may be implemented with the [Schema Validator](../event-source/schema-validator.md) pattern. Enforcing schema validation prior to writing an [Event](../event/event.md) to the [Event Stream](../event-stream/event-stream.md), allows consuming applications to delegate their data format validation logic to the schema validation layer.


## References
* See also [Stream Merger](stream-processing/event-stream-merger.md) for unifying related streams _without_ changing their format.
* This pattern is derived from [Normalizer](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Normalizer.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* Kafka Streams [`map` stateless transformation](https://docs.confluent.io/platform/current/streams/developer-guide/dsl-api.html#creating-source-streams-from-ak) documentation
