# Event Streaming Patterns

## Authoring new patterns

### Original patterns
- [Confluent wiki](https://confluentinc.atlassian.net/wiki/spaces/PM/pages/940376652/Event+Streaming+Patterns+POC)
- [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com)

### Pattern Template
Follow the pattern defined in [pattern-template.md](pattern-template.md)

### Diagrams
Use the diagrams in [this google slidedeck](https://docs.google.com/presentation/d/1Zf256Z6fBvre3uclIbmxXsDpnTIxiBX66b13pHbGIYc/edit?usp=sharing) to build new diagrams.

### Style/tech guide

- Message → Event
- All Heading names consistent, e.g. Solution Pattern → Solution
- Preamble before Problem
- Problem is a 1-line question with a question mark at the end
- Diagram shown first in Solution, before text
- All words pattern names are capitalized, e.g. Event Filter
- All mentions of patterns (not just the first mention) are hyperlinked to the target pattern 
- Use double quotes (“) (instead of single quotes (‘) in text; e.g. write “event” instead of ‘event’)
- The first mention of Kafka should be Apache Kafka®. From then on, you can freely use Apache Kafka or Kafka
- Good (for some definition of “good”) SEO metadata at the top
- Validate links (ensure patterns exist)
- Voice: state Problem as external thing (“when doing X”...no “I”), rest of text/Solution as “we”
- Bullet list: no periods unless there are multiple complete sentences within one bullet
- Avoid Kafka/implementation terms like “topics” in the introduction, Problem, Solution sections. Generally, use implementation-specific terms like “topic” only in the Implementation, Considerations, References sections.
- Add cross-references to related patterns (where applicable) to the respective “References” sections.
- Before publishing: scan for leftover `TODO` entries (such as links to content that didn’t exist yet at the time of writing a pattern)
- Once the courses are available, patterns should link to relevant courses in their "References" sections.
- Preferably, every pattern has some direct information/reference to Apache Kafka in its Implementation section.
- When the pattern is ready to be published, add it to the table of contents file at [docs/meta.yml](./docs/meta.yml).

Additional style guides (internal-access only):

- [Style Guide for Confluent Marketing](https://confluentinc.atlassian.net/wiki/spaces/GM/pages/707101991/Style+Guide+for+Confluent+Marketing)
- [Style Guide for Confluent Documentation](https://confluentinc.atlassian.net/wiki/spaces/DOC/pages/161743785/Style+Guide+for+Confluent+Documentation)

## Suggesting new patterns

### Track in GitHub
Submit a new GitHub issue in this repo, and fill out all fields in the issue template.

## Staging

### Environment
- Install `mkdocs`

```bash
brew install mkdocs
```

### Stage locally
Run:

```
mkdocs serve
```

### Stage remotely
- Make sure the branch you wish to stage is in desired state
- Run the provided script, `./release.sh`
- The updated site will be available at https://fluffy-spork-82bccf67.pages.github.io/
