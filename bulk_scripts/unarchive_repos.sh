#!/bin/bash

# Get names with `gh repo list orgname`
REPOS=(
  "org-name/repo-name"
)

for REPO in "${REPOS[@]}"; do
  gh api \
    --method PATCH \
    -H "Accept: application/vnd.github+json" \
    --silent \
    "/repos/${REPO}" \
    -F archived=false \
    && printf "\e[0;32m✓\e[0m Unarchived repository ${REPO}\n"
done
