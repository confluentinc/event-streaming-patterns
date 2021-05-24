# Event Sink
Various components in an [Event Streaming Platform](../event-stream/event-streaming-platform.md) will read or receive [Events](../event/event.md). An Event Sink is the generalization of these components, which can include [Event Processing Applications](../event-processing/event-processing-application.md), cloud services, databases, IoT sensors, mainframes, and more.

Conceptually, an event sink is the opposite of an [Event Source](../event-source/event-source.md). In practice, however, components such as an event processing application can act as both an event source and an event sink.

## Problem
How can I read (or consume / subscribe to) events in an [Event Streaming Platform](../event-stream/event-streaming-platform.md)?

## Solution

![event-sink](../img/event-sink.png)

Use an event sink, which typically acts as a client in an Event Streaming Platform. Examples are an [Event Sink Connector](event-sink-connector.md) (which continuously exports event streams from the event streaming platform into an external system such as a cloud services or a relational database) or an Event Processing Application such as a Kafka Streams application and the streaming database [ksqlDB](https://ksqldb.io/).

## Implementation

ksqlDB streaming query example: Reading events from an existing Kafka topic into a ksqlDB event stream for further processing.
```
CREATE STREAM clicks (ip_address VARCHAR, url VARCHAR, timestamp VARCHAR)
    WITH (kafka_topic = 'clicks-topic',
          value_format = 'json',
          timestamp = 'timestamp',
          timestamp_format = 'yyyy-MM-dd''T''HH:mm:ssXXX');
```

Generic Kafka Consumer application: See [Getting Started with Apache Kafka and Java](link.tbd) for a full example: 
```
consumer.subscribe(Collections.singletonList("stream"));
      while (keepConsuming) { 
        final ConsumerRecords<String, EventRecord> consumerRecords = consumer.poll(Duration.ofSeconds(1));  
        recordsHandler.process(consumerRecords); 
      }
```

## References
* The Kafka Streams library is another popular choice of developers to implement elastic applications and microservices that read, process, and write events. See [Filter a stream of events](https://kafka-tutorials.confluent.io/filter-a-stream-of-events/confluent.html) for a first example.

