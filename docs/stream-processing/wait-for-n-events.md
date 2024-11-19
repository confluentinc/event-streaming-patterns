---
seo:
  title: Wait For N Events
  description: An application can wait to trigger processing until an Event Stream has received a set number of Events.
---

# Wait For N Events

Sometimes [Events](../event/event.md) become significant after they've
happened several times.

A user can try to log in five times, but after that we'll lock their
account. A parcel delivery will be attempted three times before we ask
the customer to collect it from the depot. A gamer gets a trophy after
they've killed their hundredth Blarg.

How can we efficiently watch for logically similar Events?

## Problem

How can an application wait for a certain number of Events to occur
before performing processing?

## Solution
![wait for N events](../img/wait-for-n-events.svg)

To consider related Events as a group, we need to group them by a given key,
and then count the occurrences of that key.

## Implementation

With [Apache Flink® SQL](https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/sql/gettingstarted/), we can easily create a [Projection Table](../table/projection-table.md) that groups and counts Events by a particular key.

As an example, imagine that we are handling very large financial transactions. We only want to process these transactions after they've been reviewed and approved by two managers.

We'll start with a table of signed Events from managers:

```sql
CREATE TABLE trade_reviews (
  trade_id BIGINT,
  manager_id VARCHAR,
  signature VARCHAR,
  approved BOOLEAN
);
```

We'll group reviews by their `trade_id`, and then `COUNT()` how many approvals (`approved = TRUE`) we see for each, and only keep those with at least two (`HAVING COUNT(*) >= 2`):

```sql
CREATE TABLE approved_trades AS
    SELECT trade_id, COUNT(*) AS approvals
    FROM trade_reviews
    WHERE approved = TRUE
    GROUP BY trade_id
    HAVING COUNT(*) >= 2;
```

Query that table in one terminal:

```
SELECT * FROM approved_trades;
```

Insert some data in another terminal:

```sql
INSERT INTO trade_reviews VALUES
    (1, 'alice', '6f797a', TRUE),
    (2, 'alice', 'b523af', TRUE),
    (3, 'alice', 'fe1aaf', FALSE),
    (4, 'alice', 'f41bf3', TRUE),
    (2, 'bob', '0441ed', TRUE),
    (4, 'bob', '50f237', TRUE),
    (1, 'carol', 'ee52f5', FALSE),
    (3, 'carol', '4adb7c', TRUE);
```

This produces a the trades that are ready to process:

```noformat
   trade_id            approvals
          2                    2
          4                    2
```

## References

* See also the [Event Grouping](../stream-processing/event-grouper.md) pattern, for a more general discussion of `GROUP BY` operations.
* See chapter 15, "Building Streaming Services", of [Designing Event Driven Systems](https://www.confluent.io/designing-event-driven-systems/) for further discussion.
