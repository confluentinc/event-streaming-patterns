# Schema Compatibility
An important aspect of data management is schema evolution.
Similar to how APIs evolve and need to be compatible for all applications that rely on old and new versions of the API, schemas also evolve and likewise need to be compatible for all applications that rely on old and new versions of a schema.
This schema evolution is a natural behavior of how applications and data develop over time, it's important to have a policy about how schemas are allowed to evolve and what compatibility rules are between old and new versions.

## Problem
How do I handle addition or deletion of fields from a schema to ensure that it is compatible with previous version, such that readers do not need to make code changes to consume events?

## Solution
![schema-compatibility](../img/schema-compatibility.png)

After the initial schema for a stream is defined, applications may need to evolve it over time.
For example, there may be a new application producing similar events with a slightly different schema, both of which need to be read by the same downstream applications.
Define the rules for this stream, taking into consideration how you want to control modification of the schema's fields:

- addition of mandatory fields
- deletion of mandatory fields
- addition of optional fields
- deletion of optional fields

## Implementation
It is desirable to create the new schema and validate it out-of-band.
You can do this manually or with a schema registry service with built-in compatibility checking.

For example, if you have a new schema:

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

A schema registry service could have an interface where you submit the schema to check its compatibility against previous versions, per whatever evolution policy is defined for that schema.

```
curl -X POST --data @filename.avsc https://<schema-registry>/<subject>/versions
```

## Considerations
When updating schemas, even if they pass the schema compatibility policy, be thoughtful about the order of upgrading applications.
In some cases you should upgrade producers first, in other cases you should upgrade consumers first.
See [Compatibility Types](https://docs.confluent.io/platform/current/schema-registry/avro.html#compatibility-types) for more details.

## References
* [Schema evolution and compatibility](https://docs.confluent.io/platform/current/schema-registry/avro.html#)
