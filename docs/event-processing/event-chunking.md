---
seo:
   title: Event Chunking
   description: If an event streaming platform has some natural or configured size limit for the events, instead of storing the entire event, break it into chunks
---

# Event Chunking

Sometimes compression can reduce message size but there are various use cases that entail large message payloads where compression may not be enough.
Often these use cases are related to image, video, or audio processing: image recognition, video analytics, audio analytics, etc.

## Problem

How do I handle these use cases where the event payload is too large to move through the event streaming platform as a single event?

## Solution

![chunking](../img/event-chunking.png)

Instead of storing the entire event as a single event in the event streaming platform, break it into chunks (an approach called "chunking") so that the large event is sent across as multiple smaller events.
The producer can do the chunking when writing events into the event streaming platform.
Downstream clients consume the chunks and, when all the smaller chunks have been received, recombine ("unchunk") them to restore the original event.

## Implementation
Use metadata to track each chunk so that they can be associated to their respective parent event:

- Association between any given chunk and its parent event
- The chunk’s position in the parent event
- The total number of chunks of the parent event

## Considerations
Chunking places additional burden on client applications.
First, implementing the chunking and unchunking logic requires more application development.
Second, the consumer application needs to be able to cache the chunks as it waits to receive all the smaller chunks that comprise the original event.
This, in turn, can have implications on memory fragmentation and longer garbage collection (GC). Mitigating this depends on the programming language: in Java, for example, the JVM heap size and GC can be tuned.

Consumer client applications that are not aware of the protocol used for chunking events may not be able to reconstruct the original event accurately.

## References
* To handle large events, an alternative approach that may be preferred is [Claim Check](../event-processing/claim-check.md)
