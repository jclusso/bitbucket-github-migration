#!/bin/bash

# Get names with `gh repo list orgname`
REPOS=(
  "org-name/repo-name"
)

for REPO in "${REPOS[@]}"; do
  gh repo archive ${REPO} -y
done
