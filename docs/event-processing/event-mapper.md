# Event Mapper
Traditional applications (operating with data at rest) and [Event Processing Applications](event-processing-application.md) (with data in motion), may need to share data via the [Event Streaming Platform](../event-streaming/event-streaming-platform.md). These applications will need a common mechanism to convert data from events to domain objects and vice versa.

## Problem
How do I move data between an application’s internal data model (with domain objects) and an event streaming platform (with events) while keeping the two independent of each other?

## Solution
![event-mapper](../img/event-mapper.png)

Event Mappers provide independence between the application and the event streaming platform so that neither is aware of the other, and ideally not even of the event mapper itself.

Create (or use an existing) Event Mapper to map the Domain Model (or the application's internal data model) to the data formats accepted by the event streaming platform, and vice versa. The mapper reads the domain model and converts it into outgoing events that are sent to the event streaming platform. Conversely, a mapper can be used to create or update domain objects from incoming events.

## Implementation
Using standard Kafka producer, you can use an abstract Mapper concept to construct an Event instance (`PublicationEvent`) representing the Domain Model (`Publication`) prior to producing to Kafka.
```
private final IMapper mapper = mapperFactory.buildMapper(Publication.class);
private final Producer<String, PublicationEvent> producer = ...

public void newPublication(String author, String title) {
  Publication newPub = new Publication(author, title);
  producer.send(author/*key*/, mapper.map(newPub));
```

An application wishing to convert `PublicationEvent` instances to Domain Object updates, can do so with a Mapper that can do the reverse operation:
```
private final IMapper mapper = mapperFactory.buildMapper(Publication.class);
private final Consumer<String, PublicationEvent> consumer = ...

public void updatePublication(PublicationEvent pubEvent) {
  Publication newPub = mapper.map(pubEvent);
  domainStore.update(newPub);
```

**TODO:** Rick Feedback Request: How could we use ksqlDB or Kafka Streams her? The following KStreams example doesn't work to me because it's a stream processing application, but Mapper means to convert between domain objects and events. I'm not sure there is a logical way to "push" an event to a toplogy manually withouth producing to a topic.
```
IMapper mapper = mapperFactory.buildMapper(Publication.class);
builder.stream(inputTopic, Consumed.with(Serdes.String(), publicationSerde))
  .map((name, publication) -> mapper.map(publication))
  .to(outputTopic, Produced.with(Serdes.String(), publicationEventSerde));
```

## Considerations
**TODO:** Considerations?

## References
* This pattern is derived from [Messaging Mapper](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessagingMapper.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* **TODO:** Reference to Event-Carried State Transfer?
* **TODO:** Reference to Document Message / Event vs Command Message / Event?
* **TODO:** Is Database Write Through / CDC a valid reference?
