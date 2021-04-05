# Pattern Name
Infinite Retention Event Stream

## Problem
How can an operator ensure that events in a stream are retained forever?

## Solution Pattern
Confluent adds the ability for infinite retention by extending Apache Kafka with [Tiered Storage](https://docs.confluent.io/platform/current/kafka/tiered-storage.html#tiered-storage).  Tiered storage separates the compute and storage layers which allows the operator to scale either of those independently as needed. As records get "warm", they are moved to more cost-effective external storage like an S3 bucket.  By separating storage from compute, operators only need to add brokers to increase compute power.

![infinite-retention-event-stream](img/infinite-stream-strorage.png)

## Example Implementation
```
confluent.tier.feature=true
confluent.tier.enable=true
confluent.tier.backend=S3
confluent.tier.s3.bucket=<BUCKET_NAME>
confluent.tier.s3.region=<REGION>

# Confluent also supports using Google Cloud Storage (GCS)
```



