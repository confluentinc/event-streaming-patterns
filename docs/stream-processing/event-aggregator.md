# Event Aggregator

Combing multiple events into a single encompassing event—e.g., to compute totals or averages, or to re-aggregate events split by an [Event Splitter](../event-processing/event-splitter.md)—is a common task in event streaming and streaming analytics.

## Problem

How can multiple individual, but related events be combined to produce a new event?

## Solution
![event-aggregator](../img/event-aggregator.png)

We can build an aggregator application in which we will use a unique value in the event, perhaps a [Correlation Identifer](../docs/event/correlation-identifier.md) to find related events and add them to an aggregate if one exists.  If no aggregate exists, we create one and add the event. Then we check a completion condition and if true, we will produce a new event with that aggregate. The completion condition will vary by use case, but in our example it will be an expected total included in each event.

## Example Implementation
```
final Map<String ProcessedOrder> orders = new HashMap<>();

while (keepConsuming) {
  try {
    final ConsumerRecords<String, ProcessedItem> records = consumer.poll(Duration.ofSeconds(1));
    records.forEach(record -> {
      ProcessedOrder order = orders.get(record.key());
      if(order == null){
        order = new ProcessedOrder();
        orders.put(record.key(), order);
      }
      order.addItem(record.value());
      if (record.value().getTotal().equals(order.itemCount())){
        produceProcessedOrderEvent(order);
      }
    }
  }
  catch (Exception ex) {
    ...
  }
}
```

## Considerations
In event streaming, a key technical challenge is that it is generally not possible to tell whether input is "complete" at a given point in time. For this reason, stream processing technologies such as ksqlDB and Kafka Streams employ techniques such as grace periods (see [`GRACE PERIOD`](https://docs.ksqldb.io/en/latest/concepts/time-and-windows-in-ksqldb-queries/) clause in ksqlDB) to define cutoff points after which an [Event Processor](TODO: add link) will discard any late-arriving input events from its processing.

## References
This pattern was derived from [Aggregator](https://www.enterpriseintegrationpatterns.com/patterns/messaging/Aggregator.html) pattern in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
