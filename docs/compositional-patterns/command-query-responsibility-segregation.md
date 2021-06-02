---
seo:
  title: Command Query Responsibility Segregation
  description: 
---

# Command Query Responsibility Segregation
In some situations, updating a datastore and representing a queryable view of the data creates complexities in the implementation. Separating the two modes (write and read) into segregated models may simplifiy the implementation.

## Problem
How can we update the value in a datastore and create an associated event (with at-least-once guarantees) that updates a queryable view of the data?

## Solution
![command-query-responsibility-segregation](../img/command-query-responsibility-segregation.png)

TODO: Provide a technology agnostic diagram and supporting text explaining the pattern's implementation (placing the diagram first).

## Implementation
TODO: Technology specific code example, ksqlDB preferred. (Not every pattern will have code)

Use language keyword for code blocks, when possible:

```
```java
```python
```

## Considerations
TODO: Technology specific reflection on implmenting the pattern 'in the real world'. Considerations may include optional subsequent decisions or consequences of implementing the pattern.

## References
* TODO: Reference link to the EIP pattern as citation
* TODO: pointers to related patterns?
* TODO: pointers to external material?

