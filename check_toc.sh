#!/usr/bin/env bash

echo "< Markdown exists, no TOC entry"
echo "> TOC entry, markdown doesn't exist"

function files {
    cd docs
    find . -name '*.md' | sort
}

function toc {
    cat docs/meta.yml | yq -r '.toc[].items|.[]' | sed -e 's!.*!./&.md!' | sort
}

diff <(files) <(toc)
