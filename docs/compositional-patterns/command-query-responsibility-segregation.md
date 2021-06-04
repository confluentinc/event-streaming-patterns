---
seo:
  title: Command Query Responsibility Segregation
  description: Command Query Responsibibility Segregation (CQRS) describes segmentation of models for updating and querying of data.
---

# Command Query Responsibility Segregation (CQRS)
Databases conflate the writing of data and the reading of data in the same place: the database. In some situations, it is preferable to separate reads from writes. There are several reasons to do this but the most prevalent is that the application can now save data in the exact form in which it arrives, accurately reflecting what happened in the real world, while reading it in a different form, one that is optimized for reading. 

For example, a user adding and removing items from their cart would all be recorded as a stream of immutable events: t-shirt added, t-shirt removed, etc. These are then summarized into a separate view that used to serve reads, for example summarizing the various user events to represent the accurate contents of the cart. 

## Problem
How can we store and hold data in the exact form in which it arrived but read from a summarized and curated view?

## Solution
![command-query-responsibility-segregation](../img/command-query-responsibility-segregation.png)

Represent changes to state as [Events](../event/event.md) that describe changes to the state (commands). Subsequently, aggregate those [Events](../event/event.md) into a snapshot of the current state, allowing appliations to query for current values.

## Implementation

The streaming database [ksqlDB](https://ksqldb.io/) can implement a CQRS application natively. [Event Streams](../event-stream/event-stream.md) are built into to the streaming database design, allowing [Events](../event/event.md) to be inserted directly using SQL syntax. 

```sql
CREATE STREAM purchases (customer VARCHAR, item VARCHAR, action VARCHAR)
  WITH (kafka_topic='purchases-topic', value_format='json');
```

```sql
INSERT INTO purchases (customer, item, action) VALUES ('jsmith', 'hats', 'add');
INSERT INTO purchases (customer, item, action) VALUES ('ybyzek', 'jumpers', 'add');
INSERT INTO purchases (customer, item, action) VALUES ('jsmith', 'trousers', 'add');
INSERT INTO purchases (customer, item, action) VALUES ('ybyzek', 'hats', 'remove');
INSERT INTO purchases (customer, item, action) VALUES ('ybyzek', 'trousers', 'add');
```

Create a materialized view of the [Events](../event/event.md):

WIP
```sql
CREATE TABLE currentPurchases AS
  SELECT 
```

The current values for aggregated state can be queried by client applications using common `SELECT` syntax.
```sql
SELECT * FROM purchases 
  WHERE  <= 5 EMIT CHANGES;


## Considerations
* CQRS adds complexity over a traditional simple [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) database implementation.

* High performance applications may benefit from a CQRS design. Isolating the load of writing and reading of data may allow you to scale aspects independently and properly. 

* Microserivces applications often use CQRS to scale-out with many views provided in or for different services. The same pattern is applicable to geographically dispersed applications such as a flight booking system which are read heavy across many locations.

* A write to a CQRS system is eventually consistent. Writes cannot be read immediately as there is a delay between the write of the command [Event](../event/event.md) and the query-model being updated. This can cause complexity for some client applications, particularly online services.


## References
* See Martin Fowler's [detailed explanation of CQRS](https://martinfowler.com/bliki/CQRS.html) for more information.
