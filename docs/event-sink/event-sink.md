# Event Sink
Various components in an [Event Streaming Platform](../event-stream/event-streaming-platform.md) will read or receive [Events](../event/event.md). An Event Sink is the generalization of these components, which can include [Event Processing Applications](../event-processing/event-processing-application.md), cloud services, databases, IoT sensors, mainframes, and more.

Conceptually, an event sink is the opposite of an [Event Source](../event-source/event-source.md). In practice, however, components such as an event processing application can act as both an event source and an event sink.

## Problem
How can I read (or consume / subscribe to) events in an [Event Streaming Platform](../event-stream/event-streaming-platform.md)?

## Solution

![event-sink](../img/event-sink.png)

Use an event sink, which typically acts as a client in an Event Streaming Platform. Examples are an [Event Sink Connector](event-sink-connector.md) (which continuously exports event streams from the event streaming platform into an external system such as a cloud services or a relational database) or an Event Processing Application such as a Kafka Streams application and the streaming database [ksqlDB](https://ksqldb.io/).

## Implementation

Generic Kafka Consumer application:
```
consumer.subscribe(Collections.singletonList("stream"));
      while (keepConsuming) { 
        final ConsumerRecords<String, EventRecord> consumerRecords = consumer.poll(Duration.ofSeconds(1));  
        recordsHandler.process(consumerRecords); 
      }
```

[ksqlDB](https://ksqldb.io/) streaming query:
```
CREATE STREAM CLICKS (IP_ADDRESS VARCHAR, URL VARCHAR, TIMESTAMP VARCHAR)
    WITH (KAFKA_TOPIC = 'CLICKS',
          VALUE_FORMAT = 'JSON',
          TIMESTAMP = 'TIMESTAMP',
          TIMESTAMP_FORMAT = 'yyyy-MM-dd''T''HH:mm:ssXXX',
          PARTITIONS = 1);

```

## References
* See this [Kafka Tutorial](https://kafka-tutorials.confluent.io/creating-first-apache-kafka-consumer-application/kafka.html) for a full Kafka consumer example application
