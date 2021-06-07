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
Follow the [style/tech guide](https://docs.google.com/presentation/d/1NRAYOZdUHLCKvAy1Fc3y5OsI4w--Lgh45g9CGPmRM8g/edit#slide=id.gde62c10fe2_0_0).

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
