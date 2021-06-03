# Infinite Retention Event Stream
Many use cases demand that [Events](../event/event.md) in an [Event Stream](../event-stream/event-stream.md) will be stored for forever or for long periods of time, such as several years in the case of financial transactions because of legal requirements and compliance.

## Problem
How can we ensure that events in a stream are retained forever?

## Solution
![infinite-retention-event-stream](../img/infinite-stream-strorage.png)

The solution for infinite retention depends on the specific [Event Streaming Platform](../event-stream/event-streaming-platform.md). Some platforms support infinite retention "out of the box", requiring no action on behalf of the end users. If an [Event Streaming Platform](../event-stream/event-streaming-platform.md) does not support infinite storage, infinite retention can be partially achieved with an [Event Sink Connector](../event-sink/event-sink-connector.md) pattern which offloads [Events](../event/event.md) into permanent external storage.

## Implementation
Confluent adds the ability for infinite retention by extending Apache Kafka with [Tiered Storage](https://docs.confluent.io/platform/current/kafka/tiered-storage.html).  Tiered storage separates the compute and storage layers, allowing the operator to scale either of those independently as needed. Newly arrived records are considered "hot", but as time moves on, they get "warm" and migrate to more cost-effective external storage like an AWS S3 bucket. As cloud-native object stores can effectively scale to infinite size, the Kafka cluster can act as the system of record for infinite streams of data. Additionally, by separating storage from compute, operators only need to add brokers to increase compute power.

Tiered Storage can be enabled on a Confluent cluster with configuration:
```
confluent.tier.feature=true
confluent.tier.enable=true
confluent.tier.backend=S3
confluent.tier.<storage-provider>.bucket=<BUCKET_NAME>
confluent.tier.<storage-provider>.region=<REGION>
```

## References 
* The blog post [Infinite Storage in Confluent Platform](https://www.confluent.io/blog/infinite-kafka-storage-in-confluent-platform/) goes into further detail about tiered storage with Confluent.
* An [Event Sink Connector](../event-sink/event-sink-connector.md) can be used to implement an infinite retention event stream by loading [Event](../event/event.md) into permanent external storage.
