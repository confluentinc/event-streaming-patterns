---
seo:
  title: Partitioned Placement
  description: Topic partitions are the unit of parallelism in Kafka. Events can be written to different partitions, based on key or custom partitioner, or just round-robin across all partitions to distribute evenly.
---

# Partitioned Placement
If service goals mandate high throughput, it is useful to have the ability to distribute event storage and consumption for parallel processing.
Being able to distribute events and process them concurrently enables an application to scale.

## Problem
How can events be placed into a stream or table so that they can be processed concurrently by a distributed [Event Processor](../event-processing/event-processor.md)?

## Solution
![partitioned-placement](../img/partitioned-placement.png)

You can logically group events into a single topic, and then further group events into a topic partition.
A partition is the unit of parallelism within a topic and enables concurrent processing, helping scalability in two main ways:

1. Platform scalability: enables different brokers to store and serve events to consumer client applications concurrently
2. Application scalability: enable different consumer applications to process those events concurrently

## Implementation
When a Kafka topic is created, either by an administrator or by a streaming application like ksqlDB, you can specific the number of partitions it has.
Events are placed into a specific partition according to the partitioning algorithm, which could be based on the event key, round-robin to distribute all events across all partitions, or a custom partitioning algorithm.
All events grouped into a partition have strong ordering guarantees.

If we are using ksqlDB, the processors can scale by working on a set of partitions.
If an event stream's key content changes because of how the query wants to process the rows, for example to execute a `JOIN` operation between two streams of events, the underlying keys are recalculated, and the events are sent to a new partition in the new topic to perform the computation.

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
In general, a higher number of topic partitions results in higher throughput, and to maximize throughput, we want enough partitions to utilize all brokers in the cluster.
Although it might seem tempting just to create topics with a large number of partitions, there are tradeoffs to increasing the number of partitions.
Be sure to choose the partition count carefully based on the throughput of [Event Sources](../event-source/event-source.md) (e.g., producers in Kafka, including connectors), [Event Processors](../event-processing/event-processor.md) (e.g., ksqlDB, Kafka Streams applications), and [Event Sinks](../event-sink/event-sink.md) (e.g., consumers in Kafka, including connectors), and to benchmark performance in the environment.
Also take into consideration the design of data patterns and key assignments so that events are distributed as evenly as possible across the topic partitions.
This will prevent certain topic partitions from getting overloaded relative to other topic partitions.

## References
* [Review our guidelines](https://www.confluent.io/blog/how-choose-number-topics-partitions-kafka-cluster) for how to choose the number of partitions.
* For another approach to parallelism that subdivides the unit of work from a partition down to a key or an event, see the [Parallel Consumer](https://github.com/confluentinc/parallel-consumer).
