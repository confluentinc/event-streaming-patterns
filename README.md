# Event Streaming Patterns

This repository contains a collection of Event Streaming Patterns loosely based on [EIP Patterns](https://www.enterpriseintegrationpatterns.com/patterns/messaging/index.html) from Gregor Hohpe and Bobby Woolf. Patterns are divided up into functional categories and provide descriptions, solutions, example code, and references. 

You can see the live version of these patterns on the Confluent Developer site:
<!-- TODO: Update with proper DCI / patterns link -->
https://confluent.developer.io/patterns

## How to contribute

### Request new pattern 
If you'd like to request the creation of a new Pattern, please search the existing Patterns and issue list to prevent adding a duplicate. If you do not see an existing pattern, submit a new [GitHub issue](https://github.com/confluentinc/event-streaming-patterns/issues) using the "Pattern Request" issues template. Please provide as many details about the pattern as possible.

### Author new pattern
If you'd like to contribute a pattern, first follow the same procedure above for requesting a pattern by filing a new "Pattern request" GitHub issue. Assign the GitHub issue to yourself before proceeding.

Patterns are authored in [Markdown](https://www.mkdocs.org/user-guide/writing-your-docs/#writing-with-markdown) following the [MkDocs file layout](https://www.mkdocs.org/user-guide/writing-your-docs/). Patterns are organized into categories under the [docs](./docs/) folder and follow a naming convention of `pattern-category/pattern-name.md`.

To create a new pattern, fork the repository to your personal GitHub account. You can then use the provided [pattern-template.md](pattern-template.md) file to create a new pattern file in the proper location (`pattern-category/pattern-name.md`). The pattern template provides more details on the accepted layout and content for the pattern text.

Add your new pattern file to the table of contents file at [docs/meta.yml](./docs/meta.yml).

Reference the [Style Guide](style-guide.md) for information on writing and styling your pattern properly.

Use standard [GitHub workflow](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork) for filing a [Pull Request](https://github.com/confluentinc/event-streaming-patterns/pulls) against this project, targeting the `main` branch in the PR. Follow the PR description template and provide all of the requested information.

#### Pattern Diagram

Your pattern PR must include a diagram. The diagram should be located in the Solution section and should be a technology agnostic visual representation of the pattern's implementation. The diagrams are styled using Confluent colors and iconography. If you are a Confluent employee, you can use the diagrams in the [Google slidedeck](https://docs.google.com/presentation/d/1Zf256Z6fBvre3uclIbmxXsDpnTIxiBX66b13pHbGIYc/edit?usp=sharing) to build a new diagram. If you are not a Confluent Employee, you can provide an image in non-Confluent branding and provide it as part of the Pull Request.

### Building locally

You can build a local version of the patterns site with `mkdocs` in order to test your new pattern locally.

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

### Staging on GitHub

If you are a Confluent employee, you can stage the site using the `mkdocs` Git Hub integration. From the `main` branch (in the desired state): 
- Run the provided script, `./release.sh`
- After a few minutes, the updated site will be available at https://fluffy-spork-82bccf67.pages.github.io/

### References
- If you are a Confluent employee, you can view the origin Event Streaming Patterns POC on the [Confluent wiki](https://confluentinc.atlassian.net/wiki/spaces/PM/pages/940376652/Event+Streaming+Patterns+POC)
- [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com)

