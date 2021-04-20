# Event Translator
[Event Streaming Platforms](../event-stream/event-streaming-platform.md) will connect a variety of systems over time, and common data formats may not be feasible across them.

## Problem
How can systems using different data formats communicate with each other using [Events](../event/event.md)?

## Solution
![event-translator](../img/event-translator.png)

An Event Translator converts a data format into a standard format familiar to down stream consumers.

## Implementation
[ksqlDB](https://ksqldb.io) provides the ability to create [Event Streams](../event-stream/event-stream.md) natively using an ANSI SQL inspired syntax.

```
CREATE STREAM translated_stream AS
   SELECT
      fieldX AS fieldC,
      field.Y AS fieldA,
      field.Z AS fieldB
   FROM untranslated_stream
```


## Considerations
The [Event Standardizer](../event-processing/event-standardizer.md) pattern ties together an [Event Router](../event-processing/event-router.md) and multiple Event Translators allowing disparate systems with multiple Event formats to communicate.

## References
* This pattern is derived from [Event Translator](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageTranslator.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
