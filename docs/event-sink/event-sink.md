# Event Sink
A component that reads or receives events

## Problem
How can an application consume events?


## Solution Pattern

![event-sink](../img/event-sink.png)

The event sink is an application capable of consuming events from an event streaming platform. This application can be a generic consumer or a more complex 
[Event Processing Application](../event-processing/event-processing-application.md) such as Kafka Streams or ksqlDB.

## Example Implementation

.Generic consumer application
```
consumer.subscribe(Collections.singletonList("stream"));
      while (keepConsuming) { 
        final ConsumerRecords<String, EventRecord> consumerRecords = consumer.poll(Duration.ofSeconds(1));  
        recordsHandler.process(consumerRecords); 
      }
```

.ksqlDB streaming query
```
CREATE STREAM CLICKS (IP_ADDRESS VARCHAR, URL VARCHAR, TIMESTAMP VARCHAR)
    WITH (KAFKA_TOPIC = 'CLICKS',
          VALUE_FORMAT = 'JSON',
          TIMESTAMP = 'TIMESTAMP',
          TIMESTAMP_FORMAT = 'yyyy-MM-dd''T''HH:mm:ssXXX',
          PARTITIONS = 1);

```

## Considerations
* TODO

## References
* [Kafka Tutorial](https://kafka-tutorials.confluent.io/creating-first-apache-kafka-consumer-application/kafka.html): Kafka consumer application
