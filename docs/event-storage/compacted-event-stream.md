# Compacted Event Stream
[Event Streams](../event-stream/event-stream.md) often represent keyed snapshots of state, similar to a table in a relational database. That is, the [Events](../event/event.md) contain a primary key (identifier) and data that represents the latest information of the business entity related to the Event, such as the latest balance per customer account. [Event Processing Applications](../event-processing/event-processing-application.md) will need to process these Events to determine the current state of the business entity. However, processing the entire Event Stream history is often not practical.

## Problem
How can a (keyed) table be stored in an [Event Stream](../event-stream/event-stream.md) forever using the minimum amount of space?

## Solution
![compacted-event-stream](../img/compacted-event-stream.png)

Remove events from the Event Stream that represent outdated information and have been superseded by new Events.

## Implementation
Apache Kafka provides [Log Compaction](https://kafka.apache.org/documentation/#compaction) natively. A stream (topic in Kafka) is scanned periodically and old events are removed if they have been superseded (based on their key). It's worth nothing that this is an aysnchronous process, so a compacted stream may contain some superseded events, which are waiting to be compacted away.

To create a compacted event stream with Kafka:
```
kafka-topics --create --bootstrap-server <bootstrap-url> --replication-factor 3 --partitions 3 --topic topic-name --config cleanup.policy=compact

Created topic topic-name.
```

The `kafka-topics` command can also verify the current topics configuration:
```
kafka-topics --bootstrap-server localhost:9092 --topic topic-name --describe
Topic: topic-name       PartitionCount: 3       ReplicationFactor: 1    Configs: cleanup.policy=compact,segment.bytes=1073741824
        Topic: topic-name       Partition: 0    Leader: 0       Replicas: 0     Isr: 0  Offline:
        Topic: topic-name       Partition: 1    Leader: 0       Replicas: 0     Isr: 0  Offline:
        Topic: topic-name       Partition: 2    Leader: 0       Replicas: 0     Isr: 0  Offline:
```

## Considerations
Compacted event streams allow for some optimizations:

* First they allow the [Event Streaming Platform](../event-stream/event-streaming-platform.md) to slow down the growth of the Event Stream in a data-specific way (opposed to removing Events temporally).
* Second having smaller Event Streams allows for faster recovery or system migration strategies.

## References
* Compacted topics work a bit like simple [Log Structured Merge Trees](http://www.benstopford.com/2015/02/14/log-structured-merge-trees/).