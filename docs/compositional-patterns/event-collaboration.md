# Event Collaboration
Building distributed business workflows requires coordinating multiple services and [Event Processing Applications](../event-processing/event-processing-application.md). Business actions and reactions must be coordinated asynchronously as complex workflows transition through various states.

## Problem
How can I build a distributed workflow in a way that allows components to evolve independently? 

## Solution
![event-collaboration](../img/event-collaboration.png)

Event Collaboration allows services and applications to collaborate around a single business workflow on top of an [Event Streaming Platform](../event-stream/event-streaming-platform.md). Service components publish [Events](../event/events.md) to [Event Streams](../event-stream/event-streams.md) as notification of the completion of a step in the workflow. Stream Processing Applications observe the Events and trigger subsequent actions and resulting Events. The process repeats until the complex workflow is complete.

## Considerations
Events need to be correlated through the complex distributed workflow. The [Correlation Identifier](../event/correlation-identifier.md) pattern describes a method of coupling Events when processed asyncronously by way of a global identifier which traverses the workflow within the events.

## References
* TODO: pointers to related patterns?
* TODO: pointers to external material?

