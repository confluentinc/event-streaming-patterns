# Event Grouper

## Problem

How can I group individual but related events from the same stream/table so that they can subsequently be processed as a whole?


## Solution Pattern
![event-grouper](../img/event-grouper.png)

ksqlDB provides the capability to group related events by a column and group them into "windows" where all the related events have a timestamp
within the defined time-window.


## Example Implementation
```
SELECT product-name, COUNT(*), SUM(price) FROM purchases
  WINDOW TUMBLING (SIZE 1 MINUTE)
  GROUP BY product-name EMIT CHANGES;
```

## References
* [Session Windows](https://kafka-tutorials.confluent.io/create-session-windows/ksql.html)
* [Hopping Windows](https://kafka-tutorials.confluent.io/create-hopping-windows/ksql.html)
* [Tumbling Windows](https://kafka-tutorials.confluent.io/create-tumbling-windows/ksql.html)

