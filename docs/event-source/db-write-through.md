# Database Write Through (Change Data Capture)

## Problem
How do I update a value in a database and create an associated event with at-least-once guarantees?

This pattern is a specialization of the [Event Source Connector](event-source-connector.md) that guarantees that all state changes represented in an event source, including changes to tables in an event streaming platform, are captured in an event streaming platform.

## Solution Pattern

![db-write-through](../img/db-write-through.png)

Write to a database table, which is the Event Source. Then set up streaming Change Data Capture (CDC) on that table to continuously ingest any changes—inserts, updates, deletes—into an Event Stream in Kafka. Typically, Kafka Connect is used for this step in combination with an appropriate Event Source Connector for the database. See Confluent Hub for a list of available connectors.

The events in stream can then be consumed by Event Processing Applications. Additionally, the event stream can be read into a Projection Table, for example with ksqlDB, so that it can be queried by other applications.

## Example Implementation
TODO: Example for CDC?

## Considerations
- The processing guarantees (cf. "Guaranteed Delivery") to choose from—e.g., at-least-once, exactly-once—for the CDC data flow depend on the selected Kafka connector.
- There is a certain delay until changes in the source database table are available in the CDC-ingested event stream. The amount of the delay depends on a variety of factors, including the features and configuration of the event source connector. In many typical scenarios the delay is less than a few seconds.
- In terms of their data model, events typically require the row key to be used as the Kafka event key (aka record/message key), which is the only way to ensure all events for the same DB table row go to the same Kafka topic-partition and are thus totally ordered. They also typically model deletes as tombstone events, i.e. an event with a non-null key and a null value. By ensuring totally ordered events for each row, consumers see an eventually-consistent representation of these events for each row.

## References
* TODO: Pointers to Confluent Source connector(s)?
* TODO: What about well known CDC providers, like Debizium? 

