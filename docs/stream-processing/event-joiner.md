---
seo:
  title: Event Joiner
  description: An Event Joiner enhances an Event Stream with lookup data by joining the stream with a Table or another Event Stream.
---

# Event Joiner

[Event Streams](../event-stream/event-stream.md) may need to be joined (i.e. enriched) with a [Table](../table/state-table.md) or another Event Stream in order to provide more comprehensive details about their [Events](../event/event.md).

## Problem

How can I enrich an Event Stream or Table with additional context?

## Solution

![event joiner](../img/event-joiner.svg)

We can combine Events in a stream with a Table or another Event Stream by performing a join between the two. The join is based on a key shared by the original Event Stream and the other Event Stream or Table. We can also provide a window buffering mechanism based on timestamps, so that we can produce join results when Events from both Event Streams aren't immediately available. Another approach is to join an Event Stream and a Table that contains more static data, resulting in an enriched Event Stream. 

## Implementation

With [Apache Flink® SQL](https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/sql/gettingstarted/), we can create a continuously updating Stream of Events from an existing Kafka topic (in this example, note the similarity to [fact tables](https://en.wikipedia.org/wiki/Fact_table) in data warehouses):

```sql
CREATE TABLE ratings (
    movie_id INT NOT NULL,
    rating FLOAT
);
```

We can then create a Table from another existing Kafka topic that changes less frequently. This Table serves as our reference data (similar to [dimension tables](https://en.wikipedia.org/wiki/Dimension_(data_warehouse)) in data warehouses).

```sql
CREATE TABLE movies (
    movie_id INT NOT NULL,
    title STRING,
    release_year INT  
);
```

To create a Stream of enriched Events, we perform a join between the Event Stream and the Table.

```sql
SELECT ratings.movie_id as id, title, rating
FROM ratings
LEFT JOIN movies ON ratings.movie_id = movies.movie_id;
```

## Considerations

* We can perform an inner or left-outer join between an Event Stream and a Table.
* Joins are also useful for initiating subsequent processing when two or more corresponding Events arrive on different Event Streams or Tables.

## References

* [How to join a stream and a lookup table in Kafka Streams](https://developer.confluent.io/confluent-tutorials/joining-stream-table/kstreams/)
* [Joining a stream and a stream in Apache Flink® SQL](https://developer.confluent.io/confluent-tutorials/joining-stream-stream/flinksql/)
* [How to join a table and a table in Kafka Streams](https://developer.confluent.io/confluent-tutorials/joining-table-table/kstreams/)
