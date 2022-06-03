---
seo:
  title: Command
  description: Command Messages are a common pattern in evolving event streaming architectures, where commands are used as triggers for further processing. They may indicate opportunities for further decoupling and separation of responsibilities.
---

# Command

Messages often fall into one of two categories: [Events](../event/event.md) and commands.

Messages like events resemble simple facts--a user sends 
their new address, a product leaves the warehouse--and we record
these facts first, without immediately considering what happens next.

Others resemble commands to invoke a specific action--a user clicks a `[BUY]` button--and the system takes the action (for example, by triggering order processing).

## Problem

How can we use an [Event Streaming Platform](../event-stream/event-streaming-platform.md) to invoke a procedure in another application?

## Solution
![Command Event](../img/command-event1.svg)

Separate out the function call into a service that writes a command to
an [Event Stream](../event-stream/event-stream.md), detailing the
necessary action and its arguments. Then write a separate
service that watches for that command before invoking the
procedure.

In terms of application logic, a Command is typically dispatched in a fire-and-forget manner (commands themselves are delivered and stored with strong guarantees, such as exactly-once semantics).  The writer assumes that the command will be handled correctly, and the responsibility for monitoring and error-handling falls elsewhere in the system.  This is very similar to the Actor model: actors have an inbox, and we write messages to that inbox and trust that they will be handled in due course.

If a return value is explicitly required, the downstream service can
write a result event back to a second stream. Correlation of Command
Events with their return value is typically performed using a
[Correlation Identifier](../event/correlation-identifier.md) .

## Implementation

Suppose that we have a `[BUY]` button that should trigger a
`dispatchProduct(12005)` function call in our warehousing
system. Rather than calling the function directly, we can split the
call up. We create a command stream:

```sql
CREATE STREAM dispatch_products (
  order_id BIGINT KEY,
  address VARCHAR
) WITH (
  KAFKA_TOPIC = ' dispatch_products',
  VALUE_FORMAT = 'AVRO',
  PARTITIONS = 2
);
```

We start a process that inserts into the stream:

```sql
INSERT INTO dispatch_products ( order_id, address ) VALUES ( 12004, '1 Streetford Road' );
INSERT INTO dispatch_products ( order_id, address ) VALUES ( 12005, '2 Roadford Avenue' );
INSERT INTO dispatch_products ( order_id, address ) VALUES ( 12006, '3 Avenue Fordstreet' );
```

And finally, we start a second process that watches the stream of events and invokes the `dispatchProduct` procedure `foreach`:

```java
    ...
    Serde<GenericRecord> valueGenericAvroSerde = ...
    StreamsBuilder builder = new StreamsBuilder();

    KStream<Long, GenericRecord> dispatchStream = builder.stream(
      "dispatch_products",
      Consumed.with(Serdes.Long(), valueGenericAvroSerde)
    );

    dispatchStream.foreach((key, value) -> warehouse.dispatchProduct(key, value));
```

## Considerations

This approach works, but it may indicate a missed opportunity to improve the overall architecture of the system.

Consider what happens when we need more actions. Suppose that `[BUY]`
should also trigger an email and a text notification to the customer.
Should the warehouse software finish its work and then write
`SendEmail` and `SendText` commands to two new topics? Or should
these two new events be written by the same process that wrote `DispatchProduct`?  
A month later, when we need our sales figures, should we count the number of products dispatched, or the number of emails sent?  Should we count both, to verify that they agree?  The system grows a little more, and we have to ask, "How much code is behind that `[BUY]` button?  What's the release cycle?  Is changing it becoming a blocker?" The `[BUY]` button is important to the whole company, and rightly so, but its maintenance shouldn't hold the company to ransom.

The root problem here is that, in moving from a function call within a
monolith to a system that posts a specific command to a specific
recipient, we've decoupled the function call _without_ decoupling the
underlying concepts. When we do that, the architecture responds with
growing pains<sup>1</sup>.

A better solution is to realize that our "Command" is actually two
concepts woven together: "What happened?" and "Who needs to know?" 

By teasing those concepts apart, we can clean up our architecture. We
allow one process to focus on recording the facts of what happened,
while other processes decide for themselves if they care about those facts.  
When the `[BUY]` click happens, we should just write an `Order`
command. Then warehousing, notifications, and sales can choose to react,
without any need for coordination.

![Command Event](../img/command-event2.svg)

In short, commands are tightly coupled to an audience of one, whereas
an event should be simply a decoupled fact, available for anyone 
interested. Commands aren't bad _per se_, but they are a red flag 
signaling an opportunity for further decoupling.

Seeing systems in this way requires a slight shift of perspective--a new
way of modeling our processes--and opens up the opportunity for
systems that collaborate more easily while actually taking on less
individual responsibility.

## References

* This approach can become complex if there is a chain of functions,
  where the result of one is fed into the arguments of the next. In
  that situation, consider using [Event
  Collaboration](../compositional-patterns/event-collaboration.md).
* See [Designing Event Driven
  Systems](https://www.confluent.io/designing-event-driven-systems/)--in particular, chapter 5, "Events: A Basis for Collaboration"--for further
  discussion.
* This pattern is derived from [Command
  Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/CommandMessage.html)
  in _Enterprise Integration Patterns_, by Gregor Hohpe and Bobby Woolf.

## Footnotes

<sup>1</sup> _At this point, someone in the team will say, "We were
better off just calling the function directly."  And if we stopped
there, they would have a fair point._
