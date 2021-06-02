---
seo:
  title: Partitioned Placement
  description: Topic partitions are the unit of parallelism in Kafka. Events can be written to different partitions, based on key or custom partitioner, or just round-robin across all partitions to distribute evenly.
---

# Partitioned Placement
Applications utilizing an event streaming platform may want distributed consumption to handle the throughput or processing required.

## Problem
How can events be placed into a stream or table so that they can be processed concurrently with a distributed [Event Processor](../event-processing/event-processor.md)?

## Solution
You can logically group events into a single topic, and the unit of parallelism within the topic is a partition.
Partitions enable concurrent processing and help scalability in two ways:
Partitions help scale in two ways:

1. Platform scalability: enables different brokers to store and serve events to consumer client applications concurrently
2. Application scalability: enable different consumer applications to process those events concurrently

## Implementation
When a Kafka topic is created, either by an administrator or by a streaming application like ksqlDB, you can specific the number of partitions it has.
Then events are placed into a specific partition and the partitioning algorithm can be based on different criteria.
With Apache Kafka, it could be based on the event key, round-robin, or a custom partitioning algorithm.
Using an event key or custom partitioning algorithm has the effect of placing all records with the same identity into the same partition, which has strong ordering guarantees.

If we are using ksqlDB, the processors can scale by working on a set of partitions.
If an event stream's key content changes because of how the query wants to process the rows (via `GROUP BY` or `PARTITION BY`), the underlying keys are recalculated, and the records are sent to a new partition in the new topic to perform the computation.

```
CREATE STREAM stream_name
  WITH ([...,]
        PARTITIONS=number_of_partitions)
  AS SELECT select_expr [, ...]
  FROM from_stream
  PARTITION BY new_key_expr [, ...]
  EMIT CHANGES;
```

## Considerations
In general, a higher number of topic partitions results in higher throughput, and to maximize throughput, you want enough partitions to utilize all brokers in the cluster.
Although it might seem tempting just to create topics with a large number of partitions, there are tradeoffs to increasing the number of partitions.
Be sure to choose the partition count carefully based on producer throughput and consumer throughput and benchmark performance in your environment.
Also take into consideration the design of your data patterns and key assignments so that messages are distributed as evenly as possible across the topic partitions.
This will prevent certain topic partitions from getting overloaded relative to other topic partitions.

## References
* [Review our guidelines](https://www.confluent.io/blog/how-choose-number-topics-partitions-kafka-cluster) for how to choose the number of partitions.
* If you need another approach to parallelism that subdivides the unit of work from a partition down to a key or an event, see the [Parallel Consumer](https://github.com/confluentinc/parallel-consumer).
