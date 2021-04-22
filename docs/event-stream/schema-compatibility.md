# Schema Compatibility
Schemas are like contracts in that they set the terms that guarantee applications can process the data it receives.
A natural behavior of applications and data is that they evolve over time, so it's important to have a policy about they are allowed to evolve and what compatibility rules are between old and new versions.

## Problem
How do I ensure that a new schema is backward-compatible with a previous schema such that consumers do not need to make code changes to consume events?

## Solution
![schema-compatibility](../img/schema-compatibility.png)

Backward schema compatibility means that consumers referencing the new schema version of the schema can read data produced with the previous version of the schema.
Two types of backward compatible changes:

1. _Removal of a mandatory field_: a new consumer that was developed to process events without the field will be able to process events written with the previous schema that contain the field – the consumer will just ignore the field.
2. _Addition of an optional field_: a new consumer that was developed to process events with this optional field will be able to process events written with the previous schema that do not contain the field – the consumer will not error because the field is optional.

## Implementation
Using Avro as the serialization format, if the original schema is

```
{"namespace": "io.confluent.examples.client",
 "type": "record",
 "name": "Event",
 "fields": [
     {"name": "field1", "type": "long"},
     {"name": "field2", "type": "string"}
 ]
}
```

Examples of backward compatible changes:

1. _Removal of a mandatory field_: notice `field2` is removed

```
{"namespace": "io.confluent.examples.client",
 "type": "record",
 "name": "Event",
 "fields": [
     {"name": "field1", "type": "long"}
 ]
}
```

2. _Addition of an optional field_: notice `field3` is added with a default value of 0.

```
{"namespace": "io.confluent.examples.client",
 "type": "record",
 "name": "Event",
 "fields": [
     {"name": "field1", "type": "long"},
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
