# Dead Letter Stream

## Problem
How can an event processing application handle event processing failures without terminating on error?

## Solution Pattern
![dead-letter-stream](img/dead-letter-stream.png)

When an event stream processing system cannot process an event for an unrecoverable reason, the problematic event is published to a “dead letter stream”. This stream stores the event allowing it to be logged, reprocessed later, or otherwise acted upon.

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
* [ksqlDB Processing Log](https://docs.ksqldb.io/en/latest/reference/processing-log/)

