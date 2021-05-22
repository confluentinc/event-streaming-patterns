---
seo:
   title: Event Router
   description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec rhoncus aliquet consequat. Morbi nec lorem eget mauris posuere consequat in vel sem. Nunc ut malesuada est, fermentum tristique velit. In in odio dui. Nunc sed iaculis mauris. Donec purus tellus, fringilla nec tempor et, tristique sit amet nulla. In pharetra ligula orci, eget mattis odio luctus eu. Praesent porttitor pretium dolor, ut facilisis tortor dignissim vitae.
---

# Event Router

## Problem

How do I handle a situation where the implementation of a single logical function (e.g., inventory check) is spread across multiple physical systems?

## Solution Pattern

![event-router](../img/event-router.png)

Use the TopicNameExtractor to determine the topic to send records to.  The TopicNameExtractor has one method, `extract`, which accepts three parameters:

- The Key of the record
- The Value of the record
- The RecordContext

You can use any or all of these three to pull the required information to route records to different topics at runtime.  The `RecordContext` provides access to the headers of the record, which can contain user provided information for routing purposes.

## Example Implementation

```java
CustomExtractor implements TopicNameExtractor<String, String> {
   
   String extract(String key, String value, RecordContext recordContext) {
         // Assuming the first ten characters of the key
         // contains the information determining where 
         // Kafka Streams forwards the record.
      return key.substring(0,10);
   }

 KStream<String, String> myStream = builder.stream(...);
 myStream.mapValues(..).to( new CustomExtractor());
```

## References
* [Kafka Tutorial](https://kafka-tutorials.confluent.io/dynamic-output-topic/kstreams.html): How to dynamically choose the output topic at runtime 

