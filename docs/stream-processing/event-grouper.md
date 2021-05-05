# Event Grouper
An event grouper is a specialized form of an [Event Processor](../event-processing/event-processor.md) that groups events together by a common field such as a key in a key-value pair.

## Problem

How can an application group individual but related events from the same stream/table so that they can subsequently be processed as a whole?


## Solution
![event-grouper](../img/event-grouper.png)

Using a `group-by` [Event Processor](../event-processing/event-processor.md) in an [Event Processing Application](../event-processing/event-processing-application.md) will group the related events together.  Additionally you can use a windowing event processor to group events containing a timestamp within the size of the window. 

## Implementation
[ksqlDB](https://ksqldb.io/) provides the capability to group related events by a column and group them into ["windows"](https://docs.ksqldb.io/en/latest/concepts/time-and-windows-in-ksqldb-queries/) where all the related events have a timestamp within the defined time-window.

```
SELECT product-name, COUNT(*), SUM(price) FROM purchases
  WINDOW TUMBLING (SIZE 1 MINUTE)
  GROUP BY product-name EMIT CHANGES;
```

## Considerations
* If the field you want to group events with is embedded in the value, you can use a `select-key` event-processor to rey key the event-stream


## References
* [Session Windows](https://kafka-tutorials.confluent.io/create-session-windows/ksql.html)
* [Hopping Windows](https://kafka-tutorials.confluent.io/create-hopping-windows/ksql.html)
* [Tumbling Windows](https://kafka-tutorials.confluent.io/create-tumbling-windows/ksql.html)

