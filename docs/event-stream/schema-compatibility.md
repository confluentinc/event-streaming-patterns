---
seo:
  title: Schema Compatibility
  description: Schema Compatibility ensures that events can evolve their schemas and that old and new versions can be processed by downstream applications.
---

# Schema Compatibility
Schemas are similar to [Data Contracts](../event/data-contract.md) in that they set terms to guarantee that applications can process the data they receive.
A natural behavior of applications and data schemas is that they evolve over time, so it's important to have a policy about how they are allowed to evolve and to have compatibility rules between old and new versions.

## Problem
How do we ensure that schemas can evolve without breaking existing [Event Sinks](../event-sink/event-sink.md) (readers) and [Event Sources](../event-source/event-source.md) (writers), including [Event Processing Applications](../event-processing/event-processing-application)?

## Solution
![schema-compatibility](../img/schema-compatibility.png)

There are two types of compatibility to consider: backwards compatibility and forwards compatibility.

Backwards compatibility ensures that newer _readers_ can update their schema and continue to consume events written by older writers.
The types of backwards-compatible changes include:

* **deletion of a field:** old writers can continue to include the field, new readers ignore it
* **addition of an optional field with a default value:** old writers do not write the field, new readers use the default value

Forwards compatibility ensures that newer _writers_ can use an updated schema to produce events that can still be read by older readers.
The types of forwards-compatible changes include:

* **addition of a field:** new writers include the field, old readers ignore it
* **deletion of an optional field with a default value**: new writers do not write the field, old readers use the default value

## Implementation
Using Apache Avro&trade; as the [serialization format](../event/event-serializer.md), if the following is the original schema:

```
{"namespace": "io.confluent.examples.client",
 "type": "record",
 "name": "Event",
 "fields": [
     {"name": "field1", "type": "boolean", "default": true},
     {"name": "field2", "type": "string"}
 ]
}
```

Then examples of compatible changes would be:

1. _Removal of a nested field_: notice that `field1` is removed.

```
{"namespace": "io.confluent.examples.client",
 "type": "record",
 "name": "Event",
 "fields": [
     {"name": "field2", "type": "string"}
 ]
}
```

2. _Addition of a field with a default value_: notice that `field3` is added, with a default value of `0`.

```
{"namespace": "io.confluent.examples.client",
 "type": "record",
 "name": "Event",
 "fields": [
     {"name": "field1", "type": "boolean", "default": true},
     {"pame": "field2", "type": "string"},
     {"pame": "field3", "type": "int", "default": 0}
 ]
}
```

## Considerations
By using a [fully managed Schema Registry](https://docs.confluent.io/cloud/current/get-started/schema-registry.html) service with built-in compatibility checking, you can centralize your schemas and check compatibility of new schema versions against previous versions.

```
curl -X POST --data @filename.avsc https://<schema-registry>/<subject>/versions
```

After updating schemas and asserting the desired compatibility level, be thoughtful about the order in which you upgrade the applications that use the schemas.
In some cases, you should upgrade writer applications first (Event Sources, or consumers); in other cases, you should upgrade reader applications first (Event Sinks and Event Processors, or producers).
See [Schema Compatibility Types](https://docs.confluent.io/platform/current/schema-registry/avro.html#compatibility-types) for more details.

## References
* See also the [Event Serializer](../event/event-serializer.md) pattern, in which we encode events so that they can be written to disk, transferred across the network, and generally preserved for future readers.
* Also see the [Schema-on-Read](../event/schema-on-read.md) pattern, which enables the reader of events to determine which schema to apply to the Event that the reader is processing.
* [Schema evolution and compatibility](https://docs.confluent.io/platform/current/schema-registry/avro.html) covers backward compatibility, forward compatibility, and full compatibility.
* [Working with schemas](https://docs.confluent.io/cloud/current/client-apps/schemas-manage.html) covers how to create schemas, edit them, and compare versions.
* The [Schema Registry Maven Plugin](https://docs.confluent.io/platform/current/schema-registry/develop/maven-plugin.html#schema-registry-test-compatibility) allows you to test for schema compatibility during the development cycle.
