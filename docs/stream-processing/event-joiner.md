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

With the streaming database [ksqlDB](https://ksqldb.io/), we can create a stream of Events from an existing Kafka topic (in this example, note the similarity to [fact tables](https://en.wikipedia.org/wiki/Fact_table) in data warehouses):

```sql
CREATE STREAM ratings (MOVIE_ID INT KEY, rating DOUBLE)
    WITH (KAFKA_TOPIC='ratings');
```

We can then create a Table from another existing Kafka topic that changes less frequently. This Table serves as our reference data (similar to [dimension tables](https://en.wikipedia.org/wiki/Dimension_(data_warehouse)) in data warehouses).

```sql
CREATE TABLE movies (ID INT PRIMARY KEY, title VARCHAR, release_year INT)
    WITH (KAFKA_TOPIC='movies');

```

To create a stream of enriched Events, we perform a join between the Event Stream and the Table.

```sql
SELECT ratings.movie_id AS ID, title, release_year, rating
   FROM ratings
   LEFT JOIN movies ON ratings.movie_id = movies.id
   EMIT CHANGES;
```

## Considerations

* In ksqlDB, joins between an Event Stream and a Table are driven by the Event Stream side of the join. Updates to the Table only update the state of the Table. Only a new Event in the Event Stream will cause a new join result. For example, if we're joining an Event Stream of orders to a Table of customers, a new order will be enriched if there is a customer record in the Table. But if a new customer is added to the Table, that will not trigger the join condition. The ksqlDB documentation contains more information about [stream-table join semantics](https://docs.ksqldb.io/en/latest/developer-guide/joins/join-streams-and-tables/#semantics-of-stream-table-joins). 
* We can perform an inner or left-outer join between an Event Stream and a Table.
* Joins are also useful for initiating subsequent processing when two or more corresponding Events arrive on different Event Streams or Tables.

## References

* [How to join a stream and a lookup table in ksqlDB](https://kafka-tutorials.confluent.io/join-a-stream-to-a-table/ksql.html)
* [Joining a stream and a stream in ksqlDB](https://kafka-tutorials.confluent.io/join-a-stream-to-a-stream/ksql.html)
* [How to join a table and a table in ksqlDB](https://kafka-tutorials.confluent.io/join-a-table-to-a-table/ksql.html)
* [Performing N-way joins in ksqlDB](https://kafka-tutorials.confluent.io/multi-joins/ksql.html)
* [Joining collections](https://docs.ksqldb.io/en/latest/developer-guide/joins/join-streams-and-tables/) in the ksqlDB documentation
