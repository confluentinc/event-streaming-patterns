# Event Streaming Patterns

## Pattern Template
Follow the pattern defined in [pattern-template.md](pattern-template.md)

## Diagram creation
Use [this google sheet](https://docs.google.com/presentation/d/1Zf256Z6fBvre3uclIbmxXsDpnTIxiBX66b13pHbGIYc/edit?usp=sharing) as a method for building the diagram art.
	
## Staging instructions
- Install `mkdocs`
  - `brew install mkdocs`
- Make sure the `main` branch is in desired state
- Build and deploy the static site locally (http://127.0.0.1:8000).
  - `mkdocs serve`
- Build and deploy the static site. The following command builds the site (`site` folder), commits it to the `gh-pages` branch and pushes to GitHub.
  - `mkdocs gh-deploy`
- Commit the built site to master so the main branch is clean
  - `git commit -am 'deploy site';git push origin main` 
- The updated site will be availble here: https://fluffy-spork-82bccf67.pages.github.io/
