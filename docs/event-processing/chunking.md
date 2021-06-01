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

Instead of storing the entire event a single message in the event streaming platform, break it into chunks (an approach called "chunking") so that the single large message is sent across as multiple smaller messages.
The producer can do the chunking when writing messages into the event streaming platform.
Downstream clients would consume the chunks and when all the smaller chunks have been received, recombine them to restore the original event.

## Implementation
Use metadata to track each chunk so that they can be associated to its parent message:

- Association between any given chunk and its parent message
- The chunk’s position in the parent message
- The total number of chunks in the parent message

## Considerations
Consumer applications need to be able to cache the chunks as it waits to receive all the smaller chunks that comprise the original event.

## References
* Given the additional burden that Chunking places on the client applications, an alternative approach that may be preferred for handling large messages is [Pointers](../event-processing/pointers.md)
