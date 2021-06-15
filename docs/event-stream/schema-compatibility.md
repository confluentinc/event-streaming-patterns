# Schema Compatibility
Schemas are like contracts in that they set the terms that guarantee applications can process the data it receives.
A natural behavior of applications and data is that they evolve over time, so it's important to have a policy about how they are allowed to evolve and what compatibility rules are between old and new versions.

## Problem
How do we ensure that schemas can evolve without breaking existing [Event Sinks](../event-sink/event-sink.md) (readers) and [Event Sources](../event-source/event-source.md) (writers), including [Event Processing Applications](../event-processing/event-processing-application)?

## Solution
![schema-compatibility](../img/schema-compatibility.png)

There are two types of schema compatibility to consider.

* Backwards compatibility ensures that _readers_ can update their schema and still consume old data.
* Forwards compatibility ensures that _writers_ can update their schema and still be read by older readers.

This leaves us with two types of safe changes:

1. _Removal of a field that had a default value_: 
  * Old writers included this field; new readers will just ignore it.
  * New writers can stop writing this field; old readers will just use the old default.
2. _Addition of a field that has a default value_:
  * Old writers will not write this field; new readers will just use the new default.
  * New writers will write the new field; old readers will just ignore it.
## Implementation
Using Avro as the serialization format, if the original schema is

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

Examples of compatible changes would be:

1. _Removal of a field that had a field_: notice `field1` is removed

```
{"namespace": "io.confluent.examples.client",
 "type": "record",
 "name": "Event",
 "fields": [
     {"name": "field2", "type": "string"}
 ]
}
```

2. _Addition of a field with a default_: notice `field3` is added with a default value of 0.

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
You could use an interface of a fully-managed Schema Registry service, with built-in compatibility checking, to centralize your schemas and check compatibility of new schema versions against previous versions (or a [plugin](https://docs.confluent.io/platform/current/schema-registry/develop/maven-plugin.html#schema-registry-test-compatibility)).

```
curl -X POST --data @filename.avsc https://<schema-registry>/<subject>/versions
```

After updated schemas that pass the schema compatibility check, be thoughtful about the order of upgrading applications.
In some cases you should upgrade producers first, in other cases you should upgrade consumers first.
See [Compatibility Types](https://docs.confluent.io/platform/current/schema-registry/avro.html#compatibility-types) for more details.

## References
* [Schema compatibility](https://docs.confluent.io/platform/current/schema-registry/avro.html): backward, forward, full
* [Working with schemas](https://docs.confluent.io/cloud/current/client-apps/schemas-manage.html): creating, editing, comparing versions
