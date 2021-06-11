---
seo:
  title: Command Event
  description: Command Events are a common pattern in evolving event streaming architectures, where events are used as triggers for further processing. They may indicate opportunities for further decoupling and separation of responsibilities.
---

# Command Event

In all software systems, [events](event.md) trigger actions trigger
more events, and so on. 

Some of those events seem like plain facts - a user sends us their new
address, a product leaves the warehouse - and we record those facts
first, without immediately considering what happens next.

Other events seem more like commands to invoke a specific action - a
user clicks a `[BUY]` button - and it's time to trigger order
processing. How do we model command-like events?

## Problem

How can an [Event Streaming Platform](../event-stream/event-streaming-platform.md) be used to
invoke a procedure in another application?

## Solution
![Command Event](../img/command-event.svg)

At first glance, the solution seems simple: we just produce an event
that tells the process to begin, then have that process watch and wait
for the event to arrive.  For example, when a user clicks `[BUY]`, we
write a `DispatchProduct` event to a `warehouse` topic and ensure the
warehouse software is listening for it<sup>1</sup>.

This approach is fine and it works, but it may be a missed opportunity.

Consider what happens when we need more actions. Suppose that `[BUY]`
should also trigger an email and a text notification to the customer.
Should the warehouse software finish its work and then write
`SendEmail` and `SendText` commands to two new topics? Or should
these two new events be written by the same process that wrote `DispatchProduct`?  
Then a month later, when we need our sales figures, should we count
the number of products dispatched or the number of emails sent?
Perhaps both, to check they agree?  
The system grows a little more and we have to ask, how much code is
behind that `[BUY]` button?  What's the release cycle?  Is changing it
becoming a blocker?  `[BUY]` is important to the whole company, and
rightly so, but its maintenance shouldn't hold the company to ransom.

The root problem here is that in moving from a function call within a
monolith to a system that posts a specific command to a specific
recipient, we've decoupled the function call _without_ decoupling the
underlying concepts. When we do that, the architecture hits back with
growing pains<sup>2</sup>.

The real solution is to realize our "Command Event" is actually two
concepts woven together: "What happened?" and "Who cares?" 

By teasing those concepts apart, we can clean up our architecture. We
allow one process to focus on recording the facts of what happened,
while other processes decide for themselves if they care.  
When the `[BUY]` click happens, we should just write an `Order`
event. Then warehousing, notifications and sales can choose to react,
without any need to coordinate.

In short, commands are tightly coupled to an audience of one, whereas
an event should just be a decoupled fact, available for anyone who's
interested.  Commands aren't bad _per se_, but they are a flag that
signals an opportunity for further decoupling.

Seeing systems this way requires a slight shift of perspective - a new
way of modeling our processes - and opens up the opportunity for
systems that collaborate more easily while actually taking on less
individual responsibility.

## Implementation

Choosing the right naming and representation for events is both easy
and hard, and could be jokingly summarized with the ksqlDB command:

```sql
CREATE STREAM <choose a good name here> AS (
  <choose good names here too>
)
  ...
```

In reality, our best hope is to be aware of the distinction between
command events and data events so we can spot potential coupling
problems early, and then accept that sometimes refactoring is
inevitable and turn to [Event
Migration](../streaming-processing/event-migration.md) techniques to
revisit old design choices.

## Considerations

We've mostly focused on a single step with multiple interested
[Event Processors](../event-processing/event-processor.md) and [Event Sinks](../event-sink/event-sink.md). Many processes require a series of steps, using [Event
Collaboration](../compositional-patterns/event-collaboration.md). (For
example, you may be wondering how our buy/dispatch example above
actually handles payment.)

## References

* See [Designing Event Driven Systems](https://www.confluent.io/designing-event-driven-systems/) - "Chapter 5: Events: A Basis for Collaboration" for further discussion
* This pattern is derived from [Command Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/CommandMessage.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf

## Footnotes

_<sup>1</sup> This is very similar to the Actor model. Actors have an
inbox; we write messages to that inbox and trust they'll be handled in
due course._

_<sup>2</sup> It's at that point that someone in the team will
say, "We were better off just calling the function directly."  And if
we stopped there, they'd have a fair point._
