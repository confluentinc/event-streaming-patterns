---
seo:
  title: Content Filter
  description: A Content Filter allows an Event Processing Application to tailor events to particular use-cases, filtering out unwanted fields so we can focus on the most relevant information.
---

# Content Filter

[Events](../event/event.md) in an [Event Processing
Applications](event-processing-application.md) can often be very
large. We tend to capture data exactly as it arrives, and then work on
it, rather than processing it first and only storing the results. So
it can often be the case that the event we want to consume has much
more information in it than we actually need for the task in hand.

For example, we might pull in a product feed from a 3rd party API and
store that data exactly as it was received. Later, we might ask the
question, "How many products are in each product category?"  and find
that every event contains one hundred fields, when we're really only
interested in counting one.

At the very least this is inefficient - the network, memory and
serialization costs are one hundred times higher than they need to be.
But if we need to manually inspect the data, this actually becomes
painful; hunting through one hundred fields to find and check the one
we care about.

We need a method of storing complete events while only consuming a
subset of their fields.

## Problem

How do I simplify dealing with a large event when I am interested only
in a few data items?

## Solution

![content filter](../img/content-filter.svg)

Create an [Event Processor](./event-processor.md) that inspects each
event, pulls out the fields of interest, and passes new, smaller
events downstream for further processing.

## Implementation

In ksqlDB we can easily transform a rich event stream into a stream of
simpler event with a `SELECT` statement.

For example, assume we have an event stream called `products` where
each event contains a huge number of fields. We can prune this down
with:

```sql
CREATE OR REPLACE STREAM product_summaries AS
  SELECT
    product_id,
    category,
    sku,
    price
  FROM products;
```

## Considerations

Since filtering the content creates a new stream (and implicitly a new
topic), it's worth considering how the new stream will be
partitioned. By default the new stream will inherit the same
partitioning key as its source, but by specifying a `PARTITION BY`
clause, we can repartition the data to suit the new use case.

In the example above, our 3rd party product feed might be partitioned
by the vendor's unique `product_id`, but for this use case it might
make more sense to partition the summaries by `category`.

See the [ksqlDB
documentation](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-reference/create-stream-as-select/)
for details.

## References
* This pattern is derived from [Content
  Filter](https://www.enterpriseintegrationpatterns.com/patterns/messaging/ContentFilter.html)
  in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
* For filtering out entire events from a stream, consider an [Event
  Filter](../event-processing/event-filter.md).
