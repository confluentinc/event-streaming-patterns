# Dead Letter Stream

## Problem
How do I handle events that cannot be read for some technical reason?

## Solution Pattern
![dead-letter-stream](img/dead-letter-stream.png)

When an event stream processing system cannot process an event for an unrecoverable reason, the problematic event is published to a “dead letter stream”. This stream stores the event allowing it to be specially logged, reprocessed later, or otherwise acted upon.

## Example Implementation
```
public class DeadLetterStreamer {
  …
  public Future<RecordMetadata> report(ConsumerRecord<byte[], byte[]> orig) {
    ProducerRecord<byte[], byte[]> = dl = 
      new ProducerRecord<>(dlqTopicName, null, 
       orig.timestamp(),orig.key(), orig.value(), orig.headers());

    return this.producer.send(dl, (metadata, exception) -> {
      if (exception != null) {
        log.error("Could not produce message to dead letter stream”);
      }
    });
  }
}

public class Consumer {
  private DeadLetterStreamer dlStreamer = ...
  try {
    while (running) {
      ConsumerRecords<String, byte[]> records = consumer.poll(1000);
      for (ConsumerRecord<> record : records)
        try {
          // process record
        } catch (Exception ex) {
          dlStreamer.report(record);
        }
      }
      ...
  } finally {
    consumer.close();
  }
}
```

## Considerations
TODO: Considerations? 

## References
* TODO: pointers to external material?
* TODO: pointers to related patterns?

