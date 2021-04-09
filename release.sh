#!/bin/bash

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "releasing branch $CURRENT_BRANCH to GH Pages"
mkdocs gh-deploy
git commit -am "Deploy $CURRENT_BRANCH to site"
git push origin main
