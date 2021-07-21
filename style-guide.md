# Style guide

- Prefer the term Event over Message or Record
- All Heading names should be consistent with the [Pattern Template](../pattern-template.md)
- Patterns start with a Title which is followed immediately by a preamble. The preamble describes the general problem the reader may face. Consider explaining situations in which the pattern might be applied.
- The pattern Problem is a 1-line question with a question mark at the end. State the problem as externally (“when doing X”...not “I”), 
- The solution contains a technology agnostic description of how the pattern solves the problem. The diagram s shown first in the Solution, followed by a text explanation
- Generally, pattern name references are capitalized as proper nouns, e.g. Event Filter with the exception of very common terms, like event.
- Hyperlink the first mention of another pattern in each document (hyperlink additional mentions judiciously) 
- Use double quotes (“) (instead of single quotes (‘) in text; e.g. write “event” instead of ‘event’)
- The first mention of Kafka should be Apache Kafka®. From then on, you can freely use Apache Kafka or Kafka
- Proivde an seo front matter at the top of the document per the template
- Validate that external and pattern reference links are valid
- When writing a list: no period at the end unless there are multiple complete sentences within one bullet
- Avoid Kafka/implementation terms like “topics” in the Introduction, Problem, Solution sections. Generally, use implementation-specific terms like “topic” only in the Implementation, Considerations, References sections.
- Add cross-references to related patterns (where applicable) to the respective “References” sections.
- Before publishing: scan for leftover `TODO` entries (such as links to content that didn’t exist yet at the time of writing a pattern)
- Preferably, every pattern has some direct information/reference to Apache Kafka in its Implementation section.

## Additional style guides (Confluent internal-access only):

- [Style Guide for Confluent Marketing](https://confluentinc.atlassian.net/wiki/spaces/GM/pages/707101991/Style+Guide+for+Confluent+Marketing)
- [Style Guide for Confluent Documentation](https://confluentinc.atlassian.net/wiki/spaces/DOC/pages/161743785/Style+Guide+for+Confluent+Documentation)

