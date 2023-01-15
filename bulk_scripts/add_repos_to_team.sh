#!/bin/bash

PERMISSION="admin" # Can be one of: pull, push, admin, maintain, triage
ORG="org-name"
TEAM_SLUG="team-name"

# Get names with `gh repo list orgname`
REPOS=(
  "org-name/repo-name"
)

for REPO in "${REPOS[@]}"; do
  MESSAGE="repository ${REPO} to Org:$ORG Team:$TEAM_SLUG\n"
  # https://docs.github.com/en/rest/teams/teams#add-or-update-team-repository-permissions
  # (needs admin:org scope)
  # --silent added to make it less noisy
  gh api \
    --method PUT \
    -H "Accept: application/vnd.github+json" \
    --silent \
    "/orgs/$ORG/teams/$TEAM_SLUG/repos/$REPO" \
    -f permission="$PERMISSION" \
    && printf "\e[0;32m✓\e[0m Added $MESSAGE" \
    || printf "\e[0;31m✕\e[0m Failed to add $MESSAGE\n"
done
