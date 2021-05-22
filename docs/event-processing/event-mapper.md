---
seoTitle: Event Mapper
seoDescription: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec rhoncus aliquet consequat. Morbi nec lorem eget mauris posuere consequat in vel sem. Nunc ut malesuada est, fermentum tristique velit. In in odio dui. Nunc sed iaculis mauris. Donec purus tellus, fringilla nec tempor et, tristique sit amet nulla. In pharetra ligula orci, eget mattis odio luctus eu. Praesent porttitor pretium dolor, ut facilisis tortor dignissim vitae.
---

# Event Mapper

## Problem
How do I move data between an application’s internal data model (with domain objects) and an event streaming platform (with events) while keeping the two independent of each other?

## Solution Pattern
![event-mapper](../img/event-mapper.png)

Event Mappers provide independence between the application and the event streaming platform so that neither is aware of the other, and ideally not even of the event mapper itself.

Create (or use an existing) Event Mapper to map the Domain Model (or the application's internal data model) to the data formats accepted by the event streaming platform, and vice versa. The mapper reads the domain model and converts it into outgoing events that are sent to the event streaming platform. Conversely, a mapper can be used to create or update domain objects from incoming events.


## Example Implementation
TODO: Example?

## Considerations
The mapper may optionally validate the schema of the converted objects, see "Schema Validation".

## References
* TODO: Reference for Schema Validation 
* [Domain Model](https://en.wikipedia.org/wiki/Domain_model)
