# Event Source Connector
[Event Processing Applications](../event-processing/event-processing-application.md) may want to consume data from existing data systems, which are not themselves [Event Sources](event-source.md).

## Problem
How can we connect cloud services and traditional systems, like relational databases, to an [Event Streaming Platform](../event-stream/event-streaming-platform.md), converting their data at rest to data in motion with [Events](../event/event.md).

## Solution
![event-source-connector](../img/event-source-connector.png)

Generally speaking, we need to find a way to extract data as events from the origin system. For relational databases, for example, a common technique is to use [Change Data Capture[(https://en.wikipedia.org/wiki/Change_data_capture), where changes to database tables—such as INSERTs, UPDATES, DELETEs—are captured as events, which can then be ingested into another system. The components that perform this extraction and ingestion of events are typically called "connectors". The connectors turn the origin system into an [Event Source](../event-source/event-source.md), then generate [Events](../event/event.md) from that data, and finally sends these [Events](../event/event.md) to the [Event Streaming Platform](../event-stream/event-streaming-platform.md).

## Implementation
When connecting a cloud services and traditional systems to [Apache Kafka](https://kafka.apache.org/), the most common solution is to use [Kafka Connect](https://docs.confluent.io/platform/current/connect/index.html). There are hundreds of ready-to-use connectors available on [Confluent Hub](https://www.confluent.io/hub/), including blob stores like AWS S3, cloud services like Salesforce and Snowflake, relational databases, data warehouses, traditional message queues, flat files, and more. Confluent also provides many [fully managed Kafka connectors](https://docs.confluent.io/cloud/current/connectors/index.html) in the cloud.

There are several options to deploy such connectors. For example, the streaming database [ksqlDB](https://ksqldb.io/) provides an ability to manage Kafka connectors with SQL statements.
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
* End-to-end data delivery guarantees (such as exactly-once delivery or at-least-once delivery, cf. the [Guaranteed Delivery](../event-stream/guaranteed-delivery.md) pattern) depend primarily on three factors: (1) the capabilities of the origin Event Source, such as a cloud service or relational database; (2) the capabilities of the Event Source Connector, and (3) the capabilities of the destination Event Streaming Platform, such as Apache Kafka or Confluent.
* Security policies as well as regulatory compliance may require appropriate settings for encrypted communication, authentication, and authorization, etc. between Event Source, Event Source Connector, and the destination Event Streaming Platform.

## References
* This pattern is derived from [Channel Adapter](https://www.enterpriseintegrationpatterns.com/patterns/messaging/ChannelAdapter.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* See this [Kafka Tutorial](https://kafka-tutorials.confluent.io/connect-add-key-to-source/ksql.html) for a full Kafka Connect example
