# Event Source Connector

## Problem
How can I connect an application or system like a DB to an event streaming platform so that it can send events?

## Solution Pattern
When connecting a system like a relational database to Kafka, the most common option is to use Kafka connectors. The connector reads data from the event source, then generate events from that data, and finally sends these events to the event streaming platform.
![event-source-connector](img/event-source-connector.png)

## Example Implementation
```
CREATE SOURCE CONNECTOR JDBC_SOURCE_POSTGRES_01 WITH (
    'connector.class'= 'io.confluent.connect.jdbc.JdbcSourceConnector',
    'connection.url'= 'jdbc:postgresql://postgres:5432/postgres',
    'connection.user'= 'postgres',
    'connection.password'= 'postgres',
    'mode'= 'incrementing',
    'incrementing.column.name'= 'city_id',
    'topic.prefix'= 'postgres_'
);
```

## Considerations
* End-to-end data delivery guarantees (e.g., at-least-once or exactly-once delivery; cf. "Guaranteed Delivery") depend primarily on three factors: (1) the capabilities of the event source, such as a relational or NoSQL database; (2) the capabilities of the destination event streaming platform, such as Apache Kafka; and (3) the capabilities of the event source connector.
* Existing Kafka connectors: there are many such event source connectors readily available for Apache Kafka, e.g. connectors for relational databases or object storage systems like AWS S3.  See Confluent Hub for available connectors.
* Security policies as well as regulatory compliance may require appropriate settings for encrypted communication, authentication and authorization, etc. between event source, event source connector, and the destination event streaming platform.

## References
* [Kafka Tutorials](https://kafka-tutorials.confluent.io/connect-add-key-to-source/ksql.html): Kafka Connect Source example

