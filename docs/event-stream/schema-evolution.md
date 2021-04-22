# Schema Evolution
An important aspect of data management is schema evolution.
Similar to how APIs evolve and need to be compatible for all applications that rely on old and new versions of the API, schemas also evolve and likewise need to be compatible for all applications that rely on old and new versions of a schema.

## Problem
How do I restructure or add new information to an event in a way that ensures [Schema Compatibility](schema-compatibility.md)?

## Solution
![schema-evolution](../img/schema-evolution-1.png)

One approach for evolving this schema is "in-place", in which the single stream can have both new and previous schema versions in it, and the compatibility checks ensure that client applications can read schemas in both formats.

![schema-evolution](../img/schema-evolution-2.png)

Another approach is "dual schema upgrades", in which the event producers write to two streams, one stream with the new schema version and one stream with the previous schema version, and client applications consume from the one that they are compatible with.
Once all consumers are upgraded to the new schema, the old stream can be retired.

## Implementation
TODO: what implementation do we want to show?

## Considerations
TODO: considerations

## References
* [Schema evolution and compatibility](https://docs.confluent.io/platform/current/schema-registry/avro.html#)
