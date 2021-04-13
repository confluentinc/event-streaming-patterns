# Infinite Retention Event Stream
An infinite retention event stream enables an event streaming platform to separate storage from compute resources

## Problem
How can an operator ensure that events in a stream are retained forever?

## Solution Pattern

![infinite-retention-event-stream](../img/infinite-stream-strorage.png)

Confluent adds the ability for infinite retention by extending Apache Kafka with [Tiered Storage](https://docs.confluent.io/platform/current/kafka/tiered-storage.html#tiered-storage).  Tiered storage separates the compute and storage layers, allowing the operator to scale either of those independently as needed. Newly arrived records are considered "hot", but as time moves on, they get "warm" and migrate to more cost-effective external storage like an S3 bucket.  By separating storage from compute, operators only need to add brokers to increase compute power.


## Considerations

* An [Event Sink Connector](../event-sink/event-sink-connector.md) can be used to implement an infinite retention event stream by loading the event records into permanent external storage.

## Example Implementation
```
confluent.tier.feature=true
confluent.tier.enable=true
confluent.tier.backend=S3
confluent.tier.s3.bucket=<BUCKET_NAME>
confluent.tier.s3.region=<REGION>

# Confluent also supports using Google Cloud Storage (GCS)
```



