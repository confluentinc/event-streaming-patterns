---
seo:
   title: Pointers
   description: If an event streaming platform has some natural or configured size limit for the events, instead of storing the entire event, just store the pointer
---

# Pointers

Sometimes compression can reduce message size but there are various use cases that entail large message payloads where compression may not be enough.
Often these use cases are related to image, video, or audio processing: image recognition, video analytics, audio analytics, etc.

## Problem

How do I handle these use cases where the event payload is too large or too expensive to move through the event streaming platform?

## Solution Pattern

![pointers](../img/pointers.png)

Instead of storing the entire event in the event streaming platform, store the event payload in a persistent external store that can be shared between producers and consumers.
The producer can write the reference address into the event streaming platform, and downstream clients use the address to retrieve the event from the external store and then process it as needed.

## Implementation

The message stored in Kafka is just a pointer to the object in the external store.
This can be a full URI String, or an Object with fields for bucket and filename split out, or whatever fields are required to identify the object.

```java
  // Write object to external storage
  storageClient.putObject(bucketName, objectName, object);

  // Write URI to Kafka
  URI record = new URI(bucketName, objectName);
  producer.send(new ProducerRecord<String, URI>(topic, key, record));
```

## Considerations

The event producer is responsible for ensuring that the event is properly stored in the external store, such that the pointer passed in Kafka is a valid reference address and contains valid data.
Since the producer should be doing this atomically, take into consideration the same issues as mentioned in [Database Write Aside](../event-source/database-write-aside.md).

Also, any Kafka compaction on a topic would just remove the message with the pointer, it would not remove the data from the external store, so that data needs another expiry mechanism.

## References
* This pattern is similar in idea to [Claim Check](https://www.enterpriseintegrationpatterns.com/patterns/messaging/StoreInLibrary.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* An alternative approach to handling large messages is [Chunking](../event-processing/chunking.md)
