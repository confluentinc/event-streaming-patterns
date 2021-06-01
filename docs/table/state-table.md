# State Table

## Problem

Event streaming applications can process events in a stateless manner, filtering out undesired events or mapping values to a new type for example.  But often an event streaming application will need to perform stateful operations, such as an aggregation.  In these cases it's essential that the event streaming application have a robust mechanism for recording and updating the state for events related by key.  Ideally this state will also be local.

## Solution Pattern

![state-table](../img/state-table.png)

Developers with event streaming applications requiring state should build in the ability for the application to use a local state store.  By using local state, reads and writes will occur must faster as there is no network latency to contend with.  Also, an approach for restoring the state after a crash destroying the local store occurs.

## Example Implementation

ksqlDB provides local state out of the box for event streaming applications.  Also, the state stores are backed by changelog topics so the data in the applications is durable.

```sql
CREATE TABLE MOVIE_TICKETS_SOLD AS
    SELECT TITLE,
           COUNT(TICKET_TOTAL_VALUE) AS TICKETS_SOLD
    FROM MOVIE_TICKET_SALES
    GROUP BY TITLE
    EMIT CHANGES;
```

## References

* [State store recovery in ksqlDB](https://www.confluent.io/blog/ksqldb-state-stores-in-recovery/)


