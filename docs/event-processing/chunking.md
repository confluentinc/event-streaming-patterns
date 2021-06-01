---
seo:
   title: Chunking
   description: If an event streaming platform has some natural or configured size limit for the events, instead of storing the entire event, break it into chunks
---

# Chunking

## Problem

Sometimes compression can reduce message size but there are various use cases that entail large message payloads where compression may not be enough.
Often these use cases are related to image, video, or audio processing: image recognition, video analytics, audio analytics, etc.
How do I handle these use cases where the event payload is too large or too expensive to move through the event streaming platform?

## Solution Pattern

![chunking](../img/chunking.png)

Instead of storing the entire event a single message in the event streaming platform, break it into chunks (a design called "chunking") so that it is sent across as multiple messages.
The producer can do the chunking when writing messages into the event streaming platform, and downstream clients recombine the chunks into the original event.

## Implementation

## Considerations

## References
* An alternative approach to handling large messages is [Pointers](../event-processing/pointers.md)
