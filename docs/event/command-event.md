---
seo:
  title: Command Event
  description: Command Events are a common pattern in evolving event streaming architectures. They may indicate opportunities for further decoupling and separation of responsibilities.
---

# Command Event

In all software systems, [events](event.md) trigger actions trigger
more events, and so on. 

Some of those events seem like plain facts - a user sends us their new
address, a product leaves the warehouse - and we record those facts
first, without immediately considering what happens next.

Others events seem more like commands to invoke a specific action - a
user clicks a `[BUY]` button - and it's time to immediately trigger
order processing. How do we model command-like events?

## Problem

How can an [Event Streaming Platform](../event-stream/event-streaming-platform.md) be used to
invoke a procedure in another application?

## Solution
![Command Event](../img/command-event.svg)

At first glance, the solution seems simple: we just produce an event
that asks the process to start, then have that process block, watching
for that event to arrive.  For example, when a user clicks `[BUY]`, we
write a `DispatchProduct` event to a `warehouse` topic and ensure the
warehouse software is listening for it<sup>1</sup>.

This approach is fine and it works, but it may be a missed opportunity.

Consider what happens when we need more actions. Suppose that `[BUY]`
should also trigger an email and a text notification to the customer.
Should the warehouse software finish its work and then write
`SendEmail` and `SendText` commands to two new topics? Or should all
three events be written by the process that wrote `DispatchProduct`?  
Then a month later, when we want our sales figures, should we count
the number of products dispatched or the number of emails sent?
Perhaps both, to check they agree?  
And what's the release cycle for the software behind the `[BUY]`
button? It is destined to become a blocker for everyone that's
interested in the company's sales? `[BUY]` is important to the whole
company, and rightly so, but its software shouldn't hold the company
to ransom.

The root problem here is that in moving from a function call within a
monolithic application to a system that posts a specific command to a
specific recipient, we've decoupled the function call _without_
decoupling the underlying concepts. When we do that, the architecture
hits back with growing pains<sup>2</sup>.

The real solution is to realize our "Command Event" is actually two
concepts woven together: "What happened?" and "Who cares?" 

By teasing those concepts apart, we clean up our architecture. We
allow one process to focus on recording the facts of what happened,
and allow other process to decide for themselves if they care.  Now
when the `[BUY]` click happens, we just write an `Order` event. Then
warehousing, notifications and sales can choose to react, without any
need to coordinate.

In short, commands are tightly coupled to an audience of one, whereas
an event is a decoupled fact, available for anyone who's interested.
Commands aren't bad _per se_, but they are a flag that signals an
opportunity for further decoupling.

Seeing systems this way requires a slight shift of perspective - a new
way of modeling our processes - and opens up the opportunity of
systems that collaborate more easily while actually taking on less
individual responsibility.

_<sup>1</sup> This is very similar to an Actor model. Actors have an
inbox; we write messages to that inbox and trust they'll be acted on
in due course._

_<sup>2</sup> It's at that point that that someone in the team will
usually say, "We were better off just calling the function directly."
And if we stopped there, they'd have a fair point._

## Considerations

We've mostly focused on a single step with multiple interested
listeners. Many processes require a series of steps, using [Event
Collaboration](../compositional-patterns/event-collaboration.md). For
example, you may be wondering when our buy/dispatch example above
actually handles payment.

## References

* See [Designing Event Driven Systems](https://www.confluent.io/designing-event-driven-systems/), chapter 5 for further discussion
* This pattern is derived from [Command Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/CommandMessage.html) in Enterprise Integration Patterns by Gregor Hohpe and Bobby Woolf
