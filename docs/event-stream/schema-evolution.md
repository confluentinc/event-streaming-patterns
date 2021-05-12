# Schema Evolution
An important aspect of data management is schema evolution.
Similar to how APIs evolve and need to be compatible for all applications that rely on old and new versions of the API, schemas also evolve and likewise need to be compatible for all applications that rely on old and new versions of a schema.

## Problem
How do I restructure or add new information to an event, ideally in a way that ensures [Schema Compatibility](schema-compatibility.md)?

## Solution
![schema-evolution](../img/schema-evolution-1.png)

One approach for evolving a schema is "in-place" (shown above), in which a stream can have events with both new and previous schema versions in it. The schema compatibility checks then ensure that [Event Processing Applications](TODO: pattern link) and [Event Sinks](TODO: pattern link) can read schemas in both formats.

![schema-evolution](../img/schema-evolution-2.png)

Another approach is "dual schema upgrades" a.k.a. "versioned streams" (shown above). This approach is useful especially when breaking changes in a stream's schema(s) need to be introduced; i.e., in a situation where the new schema is incompatible to the previous schema. Here, the [Event Sources](TODO: pattern link) write to two streams:

1. One stream with the previous schema version, e.g. `payments-v1`.
2. One stream with the new schema version, e.g. `payments-v2`.

[Event Processing Applications](TODO: pattern link) and [Event Sinks](TODO: pattern link) then consume from the respective stream that they are compatible with.


Once all consumers are upgraded to the new schema, the old stream can be retired.

## Implementation
TODO: what implementation do we want to show?

## Considerations
TODO: considerations

## References
* [Schema evolution and compatibility](https://docs.confluent.io/platform/current/schema-registry/avro.html#)
* [Working with schemas](https://docs.confluent.io/cloud/current/client-apps/schemas-manage.html): creating, editing, comparing versions
