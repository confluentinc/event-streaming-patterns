# Event Streaming Patterns

This repository contains a collection of Event Streaming Patterns loosely based on [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com/patterns/messaging/index.html) from Gregor Hohpe and Bobby Woolf. Patterns are divided up into functional categories and provide descriptions, solutions, example code, and references. 

You can see the live version of these patterns on the Confluent Developer site:
<!-- TODO: Update with proper DCI / patterns link -->
https://confluent.developer.io/patterns

## Questions?

Please head over to the [Confluent Community Forum](https://forum.confluent.io/) if you have questions or suggestions.

## How to contribute

### Request a new pattern 

If you'd like to request the creation of a new Pattern, please search the existing Patterns and [GitHub issue list](https://github.com/confluentinc/event-streaming-patterns/issues) to avoid adding a duplicate. If you do not see an existing pattern or issue, please submit a new [GitHub issue](https://github.com/confluentinc/event-streaming-patterns/issues) using the "Pattern request" issues template, providing as many details about the pattern as possible.

### Write a new pattern

#### Workflow

If you'd like to contribute a pattern, first follow the same procedure above, searching through existing GitHub issues or requesting a new pattern. Assign the GitHub issue to yourself before proceeding.

Fork the repository to your personal GitHub account. You can then copy the provided [pattern-template.md](pattern-template.md) file, which has details on the accepted layout and content for the pattern text, to create a new pattern file. Put the pattern file in the proper location, following a naming convention of `pattern-category/pattern-name.md`.

Patterns are authored in [Markdown](https://www.mkdocs.org/user-guide/writing-your-docs/#writing-with-markdown) following the [MkDocs file layout](https://www.mkdocs.org/user-guide/writing-your-docs/).
Reference the [Style Guide](style-guide.md) for information on writing and styling your pattern properly.

Add your new pattern file to the table of contents file at [docs/meta.yml](./docs/meta.yml).

Once your pattern is complete, use standard [GitHub workflow](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork) for filing a [Pull Request](https://github.com/confluentinc/event-streaming-patterns/pulls) against this project, targeting the `main` branch in the PR. Follow the PR description template and provide all of the requested information.

#### Pattern Diagram

Your new pattern must include a diagram in the `Solution` section, and it should be a technology agnostic visual representation of the pattern's implementation. The diagrams are stylized using Confluent colors and iconography. If you are a Confluent employee, you can use the diagrams in the [Google slidedeck](https://docs.google.com/presentation/d/1Zf256Z6fBvre3uclIbmxXsDpnTIxiBX66b13pHbGIYc/edit?usp=sharing) to build a new diagram. If you are not a Confluent Employee, you can provide an image in non-Confluent branding and provide it as part of the PR, and we can help you stylize it.

#### Build locally

To test your new pattern locally, you can build a local version of the patterns site with `mkdocs`.

- Install `mkdocs` (https://www.mkdocs.org/)

    On macOS, you can use Homebrew:
    ```bash
    brew install mkdocs
    ```

- Build and serve a local version of the site. In this step, `mkdocs` will give you information if you have any errors in your new pattern file.
    ```
    mkdocs serve
    ```

- Point a web browser to the local site at http://localhost:8000 and navigate to your new pattern.

#### Staging on GitHub

If you are a Confluent employee, you can stage the site using the `mkdocs` GitHub integration. From the `main` branch (in the desired state):
- Run the provided script, `./release.sh`
- After a few minutes, the updated site will be available at https://fluffy-spork-82bccf67.pages.github.io/

### References

- [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com)
