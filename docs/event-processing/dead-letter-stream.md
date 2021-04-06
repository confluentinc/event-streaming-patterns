# Dead Letter Stream

Event processing applications may encounter invalid data as they operate over the infinite stream of events. Errors may include invalid data formats, nonsensical, missing or corrupt values, technical failures, or other unexpected scenarios.

## Problem
How can an event processing application handle processing failures without terminating on a single error?

## Solution Pattern
What can the application do with an event it cannot process?

![dead-letter-stream](../img/dead-letter-stream.png)

When the event processing application cannot process an event for an unrecoverable reason, the problematic event is published to a “dead letter stream”. This stream stores the event allowing it to be logged, reprocessed later, or otherwise acted upon. Additional contextual information can be provided in the "dead letter event", for example exception details, to ease fault resolution later.

## Example Implementation
```
public class DeadLetterStreamer {
  …
  public Future<RecordMetadata> report(ConsumerRecord<byte[], byte[]> badRecord, Exception ex) {
    return this.producer.send(new ProducerRecord<>(/*badRecord and Exception data*/);
  }
}

ConsumerRecords<String, byte[]> records = consumer.poll(1000);
for (ConsumerRecord<> record : records) {
  try {
    // process record
  } catch (Exception ex) {
    dlStreamer.report(record, ex);
  }
}
```

## Considerations
TODO: Considerations? 

## References
* [Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html)
* [ksqlDB Processing Log](https://docs.ksqldb.io/en/latest/reference/processing-log/)
