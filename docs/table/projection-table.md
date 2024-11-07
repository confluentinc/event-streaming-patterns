---
seo:
  title: Projection Table
  description: A Projection Table acts as a materialized view of an Event Stream or change log, grouping and summarizing events into a unified state.
---

# Projection Table

One of the first questions we want to ask of a stream of events is, "Where are we now?"

If we have a stream of sales events, we'd like to have the total sales figures at our fingertips. If we have a stream of `login` events, we'd like to know when each user last logged in. If our trucks send GPS data every minute, we'd like to know where each truck is right now.

How do we efficiently roll up data? How do we preserve a complete event log and enjoy the fast queries of an "update-in-place" style database?

## Problem

How can a stream of change events be efficiently summarized to give the current state of the world?

## Solution
![Projection Table](../img/projection-table.svg)

We can maintain a projection table that behaves just like a materialized view in a traditional database. As new events come in, the table is automatically updated, constantly giving us a live picture of the system. Events with the same key are considered related; newer events are interpreted, depending on their contents, as updates to or deletions of older events.

As with a materialized view, projection tables are read-only. To change a projection table, we change the underlying data by recording new events to the table's underlying stream.

## Implementation

[Apache Flink®](https://nightlies.apache.org/flink/flink-docs-stable/) supports [dynamic tables](https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/concepts/dynamic_tables/#dynamic-tables-amp-continuous-queries) as a core concept in its Table API and SQL support. A continuous query on a dynamic table in Flink is very similar to a materialized view in a traditional database.

As an example, imagine that we are shipping packages around the world. As a package reaches each point on its journey, it is logged with its current location.

Let's start with a stream of package check-in events:

```sql
CREATE TABLE package_checkins (
    package_id INT,
    location STRING
);
```

To track each package's most recent `location`:

```sql
CREATE TABLE current_package_locations AS
  SELECT
    package_id,
    LAST_VALUE(location) OVER w AS location
  FROM package_checkins
  WINDOW w AS (
    PARTITION BY package_id
    ORDER BY $rowtime
    ROWS BETWEEN UNBOUNDED PRECEDING
      AND CURRENT ROW
  );
```

As new data is inserted into the `package_checkins` table, the `current_package_locations` table is updated, so we can see the current location of each package without scanning through the event history every time.

## References

* Flink SQL [window functions][https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/hive-compatibility/hive-dialect/queries/window-functions/]
* See also the [State Table](../table/state-table.md) pattern.
