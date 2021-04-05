# Event Streaming Patterns

## Staging instructions
- Make sure the `main` branch is in desired state
- Build and deploy the static site using `mkdocs`. The following command builds the site (`site` folder), commits it to the `gh-pages` branch and pushes to GitHub. 
  - `mkdocs gh-deploy`
- Commit the built site to master so the main branch is clean
  - `git commit -am 'deploy site';git push origin main` 
