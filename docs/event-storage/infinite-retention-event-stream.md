# Infinite Retention Event Stream
Storing all [Events](../event/event.md) over time of an [Event Stream](../event-stream/event-stream.md) enables systems to be agile and evolve by providing the capability of rebuilding global historical state.

## Problem
How can an operator ensure that events in a stream are retained forever?

## Solution
![infinite-retention-event-stream](../img/infinite-stream-strorage.png)

## Implementation
Confluent adds the ability for infinite retention by extending Apache Kafka with [Tiered Storage](https://docs.confluent.io/platform/current/kafka/tiered-storage.html#tiered-storage).  Tiered storage separates the compute and storage layers, allowing the operator to scale either of those independently as needed. Newly arrived records are considered "hot", but as time moves on, they get "warm" and migrate to more cost-effective external storage like an S3 bucket.  By separating storage from compute, operators only need to add brokers to increase compute power.

```
confluent.tier.feature=true
confluent.tier.enable=true
confluent.tier.backend=S3
confluent.tier.<storage-provider>.bucket=<BUCKET_NAME>
confluent.tier.<storage-provider>.region=<REGION>
```

## References 
* An [Event Sink Connector](../event-sink/event-sink-connector.md) can be used to implement an infinite retention event stream by loading the event records into permanent external storage.

