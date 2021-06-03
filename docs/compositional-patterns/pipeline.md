# Pipeline

A single stream of events can be used by multiple services and may need to go through multiple transformations along the way. 

## Problem

How can we transform a stream of events in separate stages while making the events available at each stage?

## Solution Pattern
![pipeline](../img/pipeline.png)

We can run a stream of events through a series of transformations, connected in  a pipeline, using ksqlDB and Kafka topics.

## Example Implementation
```
CREATE STREAM orders ( 
  customer_id INTEGER, items ARRAY<STRUCT<name VARCHAR, price DOUBLE>>
) WITH (
  kafka_topic = 'orders', partitions = 1, value_format = 'AVRO'
);
```

```
CREATE STREAM orders_enriched WITH 
(KAFKA_TOPIC='orders_enriched', PARTITIONS=1, VALUE_FORMAT='AVRO')
AS SELECT o.customer_id AS cust_id, o.items, c.name, c.address
FROM orders o LEFT JOIN customers c 
ON o.customer_id = c.customer_id
EMIT CHANGES;
```

```
CREATE STREAM orders_totaled 
WITH (KAFKA_TOPIC='orders_totaled', PARTITIONS=1, VALUE_FORMAT='AVRO')
AS SELECT cust_id, items, name, address,  
  REDUCE(TRANSFORM(items, i=> i->price ), 0E0, (i,x) => (i + x)) AS total 
FROM orders_enriched EMIT CHANGES;
```

## Considerations
The same stream of events may participate in multiple pipelines, and though each pipeline can be viewed as a stand-alone application, components may be playing a role in multiple pipelines.

## References
This pattern was influenced by [Piple and Filters](https://www.enterpriseintegrationpatterns.com/patterns/messaging/PipesAndFilters.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf but is much more powerful and flexible because it is using Kafka topics as the pipes.

