---
seo:
  title: Event Mapper
  description: The Event Mapper moves data between domain objects and Events in an Event Streaming Platform.
---

# Event Mapper
Traditional applications, which work with data at rest, and [Event Processing Applications](event-processing-application.md), which work with data in motion, may need to share data via an [Event Streaming Platform](../event-stream/event-streaming-platform.md). These applications need a common mechanism to convert data from [Events](../event/event.md) to domain objects and vice versa.

## Problem
How can I move data between domain objects in an application’s internal data model and Events in an Event Streaming Platform, while keeping the two independent of each other?

## Solution
![event-mapper](../img/event-mapper.svg)

An Event Mapper provides independence between the traditional application and the Event Streaming Platform, so that neither is aware of the other (and ideally, neither is even aware of the event mapper itself).

Create an Event Mapper, or use an existing one, to map the [domain model](https://en.wikipedia.org/wiki/Domain_model) (or the application's internal data model) to the data formats accepted by the Event Streaming Platform, and vice versa. The Event Mapper reads the domain model and converts it into outgoing Events, which are sent to the Event Streaming Platform. Conversely, an Event Mapper can be used to create or update domain objects based on incoming Events.

## Implementation
In this example, we use the Java producer client of Apache Kafka&reg; to implement an Event Mapper that constructs an [Event](../event/event.md) (`PublicationEvent`) from the domain model object (`Publication`) before the event is written to an [Event Stream](../event-stream/event-stream.md) (called a "topic" in Kafka).

```java
private final IMapper domainToEventMapper = mapperFactory.buildMapper(Publication.class);
private final Producer<String, PublicationEvent> producer = ...

public void newPublication(String author, String title) {
  Publication newPub = new Publication(author, title);
  producer.send(author /* event key */, domainToEventMapper.map(newPub));
```

We can implement the reverse operation in a second Event Mapper that converts `PublicationEvent` Events back into domain object updates:
```java
private final IMapper eventToDomainMapper = mapperFactory.buildMapper(Publication.class);
private final Consumer<String, PublicationEvent> consumer = ...

public void updatePublication(PublicationEvent pubEvent) {
  Publication newPub = eventToDomainMapper.map(pubEvent);
  domainStore.update(newPub);
```

## Considerations

The Event Mapper may optionally validate the schema of the converted objects. For details, see the [Schema Validator](../event-source/schema-validator.md) pattern.

## References
* This pattern is derived from [Messaging Mapper](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessagingMapper.html) in _Enterprise Integration Patterns_, by Gregor Hohpe and Bobby Woolf.
* See also the [Event Serializer](../event/event-serializer.md) and [Event Deserializer](../event/event-deserializer.md) patterns.
