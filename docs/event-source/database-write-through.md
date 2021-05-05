# Database Write Through
For architectural or legacy purposes, data centric applications may write directly to a database. [Event Processing Applications](../event-processing/event-processing-application.md) will need to reliably consume data from these systems using [Events](../event/event.md) on [Event Streams](../event-stream/event-stream.md).

## Problem
How do I update a value in a database and create an associated Event with at-least-once guarantees?

## Solution
![db-write-through](../img/database-write-through.png)

Applications write directly to a database table, which is the [Event Source](event-source.md). Deploy a Change Data Capture (CDC) solution to continuously capture writes (inserts, updates, deletes) to that table and produce them as Events onto an Event Stream.  The events in stream can then be consumed by Event Processing Applications. Additionally, the event stream can be read into a Projection Table, for example with ksqlDB, so that it can be queried by other applications.

## Implementation
**TODO:** Implementation for this pattern?  Kafka Connect config / create example?

## Considerations
- This pattern is a specialization of the [Event Source Connector](event-source-connector.md) that guarantees that all state changes represented in an Event Source are captured in an Event Streaming Platform.
- The processing guarantees (cf. "Guaranteed Delivery") to choose from—e.g., at-least-once, exactly-once—for the CDC data flow depend on the CDC and Database technology utilizied.
- There is a certain delay until changes in the source database table are available in the CDC-ingested event stream. The amount of the delay depends on a variety of factors, including the features and configuration of the Event Source Connector. In many typical scenarios the delay is less than a few seconds.
- In terms of their data model, events typically require the row key to be used as the Kafka event key (aka record/message key), which is the only way to ensure all events for the same DB table row go to the same Kafka topic-partition and are thus totally ordered. They also typically model deletes as tombstone events, i.e. an event with a non-null key and a null value. By ensuring totally ordered events for each row, consumers see an eventually-consistent representation of these events for each row.

## References
* See [Integrate External Systems to Kafka](https://docs.confluent.io/cloud/current/connectors/index.html) on Confluent documentation for information on source connectors.
* **TODO:** What about well known CDC providers, like Debezium? 

