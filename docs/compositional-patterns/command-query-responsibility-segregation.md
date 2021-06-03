---
seo:
  title: Command Query Responsibility Segregation
  description: 
---

# Command Query Responsibility Segregation
Databases conflate the writing of data and the reading of data in the same place: the database. In some situations, it is preferable to separate reads from writes. There are several reasons to do this but the most prevalent is that the application can now save data in the exact form in which it arrives, accurately reflecting what happened in the real world, while reading it in a different form, one that is optimized for reading. 
For example, a user adding and removing items from their cart would all be recorded as a stream of immutable events: t-shirt added, t-shirt removed, etc. These are then summarized into a separate view that used to serve reads, for example summarizing the various user events to represent the accurate contents of the cart. 

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
